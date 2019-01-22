require_relative 'lib/message'
require_relative 'lib/thread'
require_relative 'lib/user'
require 'archive/zip'

puts 'Укажите путь к файлу'

zip_file = STDIN.gets.chomp

#time = Time.now

Archive::Zip.extract("#{zip_file}", "unzipped")

user_path = File.dirname(__FILE__) + "/unzipped/users.json"

users_info = User.from_json(user_path)


