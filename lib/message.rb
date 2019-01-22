require 'json'

class Message
  attr_reader :user, :text, :thread_ts

  def self.from_json(message_path, user_path)
    message_path = File.read(message_path, encoding: 'utf-8')
    data_hash = JSON.parse(message_path)
    users = User.from_json(user_path)
    user = users.real_name

    self.new(
      user: user,
      text: data_hash.map { |text| text['text'] },
      thread_ts: data_hash.map { |thread_ts| thread_ts['thread_ts'] }
    )
  end

  def initialize(params)
    @user = params[:user]
    @text = params[:text]
    @thread_ts = params[:thread_ts]
  end

  def to_s
    "#{@text}\n"
  end
end