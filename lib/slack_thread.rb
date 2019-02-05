class SlackThread
  attr_reader :thread_ts, :messages

  def initialize(thread_ts, messages)
    @thread_ts = thread_ts
    @messages = messages
  end

  def to_s
    "#{@thread_ts}: #{@messages}"
  end
end
