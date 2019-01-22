require 'json'

class User
  attr_reader :id, :real_name, :thread_ts

  def self.from_json(user_path)
    user_path = File.read(user_path, encoding: 'utf-8')
    data_hash = JSON.parse(user_path)

    self.new(
        id: data_hash.map { |id| id['id'] },
        real_name: data_hash.map { |real_name| real_name['real_name'] }
    )
  end

  def initialize(params)
    @id = params[:id]
    @real_name = params[:real_name]
  end

  def to_s
    "Пользователь: #{@real_name}, id: #{@id}"
  end
end