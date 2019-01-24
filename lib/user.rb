class User
  attr_reader :id, :real_name

  def initialize(id, real_name)
    @id = id
    @real_name = real_name
  end

  def to_s
    "#{@id} #{@real_name}"
  end
end