require_relative 'lib/message'
require_relative 'lib/user'
require_relative 'lib/slack_thread'
require 'archive/zip'
require 'json'
require 'csv'
require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.on('-p PATH', '--path PATH', 'Путь к файлу') { |o| options[:path] = o }
end.parse!

zip_file = options[:path]

current_path = File.dirname(__FILE__)

Archive::Zip.extract(
    zip_file.to_s,
    current_path + '/tmp/unzipped',
    create: false,
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

# Массив всех сообщений
messages = []

Dir.glob(current_path + '/tmp/unzipped/general/*.json') do |file|
  message_files = File.read(file, encoding: 'utf-8')
  message_hash = JSON.parse(message_files)
  message_hash.each do |el|
    msg = Message.new(el['user'], el['text'], el['thread_ts'])
    messages << msg
  end
end

# Уникальные Thread_ts
uniq_thread_ts = messages.map(&:thread_ts).uniq

# Массив тредов
threads = []

uniq_thread_ts.each do |tts|
  thread_messages = messages.select { |el| el.text if el.thread_ts == tts }
  thread = SlackThread.new(tts, thread_messages)
  threads << thread
end

# Сохраняем в CSV
CSV.open('slack_threads.csv', 'w') do |csv|

end