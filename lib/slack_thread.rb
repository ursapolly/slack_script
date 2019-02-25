class SlackThread
  attr_reader :thread_ts, :messages

  def initialize(thread_ts, messages)
    @thread_ts = thread_ts
    @messages = messages
  end

  def user_attended?(user_id)
    self.messages.any? {|el| el.user == user_id}
  end

  def to_s
    "#{@thread_ts}"
  end
end
