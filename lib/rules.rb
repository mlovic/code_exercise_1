class PricingRule
  def initialize(name = nil, &block)
    raise ArgumentError, "Rule must be initialized with a block" unless block_given?
    @name = name
    @operation = block
  end

  # Returns the amount to be discounted (subtracted) for the collection of items
  def apply_discount items, prices
    @operation.call items, prices
  end
end

GREEN_TEA_PROMO = 
  PricingRule.new("Summer green tea promotion") do |items, prices|
    (items["GR1"] / 2) * prices["GR1"]
  end

STRAWBERRIES_BULK_PROMO = 
  PricingRule.new do |items, _|
    num_strawberries = items["SR1"] || 0
    num_strawberries >= 3 ? num_strawberries * 0.5 : 0
  end

# Could also be:
#
# class BuyXGetOneFree < PricingRule
#   def initialize(item, x)
#     @discount_fn = lambda do |items, prices|
#       (items[item] / (x + 1)) * prices[item]
#     end
#   end
# end
#
# GREEN_TEA_PROMO = BuyXGetOneFree.new "GR1", 1
