require 'date'

class Thread
  attr_reader :thread_ts

  def initialize(params, file_name)
    @thread_ts = params[:thread_ts]
    @date = Date.parse(file_name)
    @start_time = @thread_ts
  end
end