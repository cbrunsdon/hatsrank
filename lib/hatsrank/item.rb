class Item
  attr_accessor :name, :descriptions
  def initialize
    @descriptions = []
  end

  def effects
    descriptions.select { |x| x.value.match /^Effect/ }
  end
end
