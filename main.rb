require_relative 'lib/message'
require_relative 'lib/user'
require_relative 'lib/slack_thread'
require 'archive/zip'
require 'json'
require 'csv'
require 'optparse'
require 'date'
require 'yaml'
require 'fileutils'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: main.rb [options]'
  opt.on('-h', 'Помощь') do
    puts opt
    exit
  end

  opt.on('-p PATH', '--path PATH', 'Путь к файлу') { |o| options[:path] = o }
end.parse!

zip_file = options[:path]

current_path = File.dirname(__FILE__)

Archive::Zip.extract(
    zip_file.to_s,
    current_path + '/tmp/unzipped',
    create: true,
    overwrite: :older
)

user_path = current_path + '/tmp/unzipped/users.json'
users_file = File.read(user_path, encoding: 'utf-8')
users_hash = JSON.parse(users_file)

# Массив юзеров
users = []
users_hash.each do |el|
  usr = User.new(el['id'], el['real_name'])
  users << usr
end

users.reject! { |el| el.real_name == nil }

# Массив всех сообщений
messages = []
Dir.glob(current_path + '/tmp/unzipped/general/*.json') do |file|
  message_files = File.read(file, encoding: 'utf-8')
  message_hash = JSON.parse(message_files)
  message_hash.each do |el|
    msg = Message.new(el['user'], el['text'], el['thread_ts'], el['ts'])
    messages << msg
  end
end

# Уникальные Thread_ts
uniq_thread_ts = messages.map(&:thread_ts).uniq.compact!

# Массив тредов
threads = []
uniq_thread_ts.each do |tts|
  thread_messages = messages.select { |el| el.text if el.thread_ts == tts }
  thread = SlackThread.new(tts, thread_messages)
  threads << thread
end

Dir.glob(current_path + '/tmp/threads/*.csv') { |f| FileUtils.rm(f) }

date = Time.now.strftime('saved_thread_%Y.%m.%d_%H:%M')
csv_file = "tmp/threads/#{date}.csv"
headers = %w(ts real_name text count slack_url user_id)

CSV.open(csv_file, 'w', write_headers: true, headers: headers) do |csv|
  yaml_data = YAML.load(File.read('config/config.yml'))
  yaml_data['user_id'].each do |id|
    user_id = id

    threads.each do |el|
      fm = el.messages.find(&:first_message)
      rn = users.select { |u| u if u.id == fm.user }.first
      if el.user_attended?(id)
        ts = Time.at(el.thread_ts.to_i).strftime('%d.%m.%Y %H:%M')
        real_name = case rn
                    when nil then 'Имя недоступно'
                    else
                      rn.real_name
                    end
        text = fm.text[0, 148]
        count = el.messages.count
        slack_url = "#{yaml_data['slack_url']}/CE93E30QY/p#{el.thread_ts.gsub('.', '')}"
        csv << [ts, real_name, text, count, slack_url, user_id]
      end
    end
  end
end

FileUtils.remove_dir(current_path + '/tmp/unzipped')

if File.exist?(csv_file)
  puts 'Файл схранён в папку "tmp/threads"!'
else
  puts 'Что-то пошло не так...'
end
