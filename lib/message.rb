require 'json'

class Message
  def read_message(file_path)
    @file = File.read(file_path, encoding: 'utf-8')
    @data_hash = JSON.parse(@file)
    @message = @data_hash['text']
  end
end
