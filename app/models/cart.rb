class Cart

  def initialize(contents)
    @contents = contents || Hash.new()
  end

  def total_count
    @contents.values.sum
  end
end
