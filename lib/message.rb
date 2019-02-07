class Message
  attr_reader :user, :text, :thread_ts

  def initialize(user, text, thread_ts)
    @user = user
    @text = text
    @thread_ts = thread_ts
  end

  def to_s
    "#{@text}n"
  end
end