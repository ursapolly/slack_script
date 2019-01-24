class Message
  attr_reader :user, :text, :thread_ts

  def initialize(user, text, thread_ts)
    @user = user
    @text = text
    @thread_ts = thread_ts
  end

  def to_s
    "#{@user}: #{@text}, #{@thread_ts}\n"
  end
end