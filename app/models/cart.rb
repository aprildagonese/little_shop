class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def add_item(id)
    if @contents[id] == nil
      @contents[id] = 1
    else
      @contents[id] += 1
    end
  end

  def grand_total
    grand_total = 0
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      grand_total += item.subtotal
    end
    grand_total
  end
end
