require_relative 'lib/message'
require_relative 'lib/thread'
require_relative 'lib/user'
require 'archive/zip'

puts 'Укажите путь к файлу'

zip_file = STDIN.gets.chomp

Archive::Zip.extract("#{zip_file}", "unzipped")

current_path = File.dirname(__FILE__)

user_path = current_path + "/unzipped/users.json"

#сusers_info = User.from_json(user_path)

#Dir.glob(current_path + "/unzipped/general/*.json") do |file|
#  messages = Message.from_json(file, user_path)
#  puts messages.user
#end

