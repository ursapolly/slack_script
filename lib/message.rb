class Message
  attr_reader :user, :text, :thread_ts, :ts

  def initialize(user, text, thread_ts, ts)
    @user = user
    @text = text
    @thread_ts = thread_ts
    @ts = ts
  end

  def first_message
    @thread_ts == @ts
  end

  def to_s
    "#{@text}n"
  end
end