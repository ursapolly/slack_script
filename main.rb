require_relative 'lib/message'
require_relative 'lib/user'
require_relative 'lib/slack_thread'
require 'archive/zip'
require 'json'

# Получаем файлы из архива и сохраняем в папку
puts 'Укажите путь к файлу'

zip_file = STDIN.gets.chomp

# Путь, где лежит проект
current_path = File.dirname(__FILE__)

# Получаем данные из архива
Archive::Zip.extract(
    zip_file.to_s,
    current_path + '/tmp/unzipped',
    create: false,
    overwrite: :older
)

# Получаем путь к юзерам
user_path = current_path + '/tmp/unzipped/users.json'

# Читаем json-файл
users_file = File.read(user_path, encoding: 'utf-8')

# Получаем из него хеш со всеми данными
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

# Массив уникальных Thread_ts
uniq_thread_ts = []

messages.each do |el|
  uniq_thread_ts << el.thread_ts
  uniq_thread_ts.uniq!
end

uniq_thread_ts.each do |item|
end