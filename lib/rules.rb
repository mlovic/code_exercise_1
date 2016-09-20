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

VOUCHER_PROMO = 
  PricingRule.new("Summer voucher promotion") do |items, prices|
    (items["VOUCHER"] / 2) * prices["VOUCHER"]
  end

TSHIRT_BULK_PROMO = 
  PricingRule.new do |items, _|
    num_tshirts = items["TSHIRT"]
    num_tshirts >= 3 ? num_tshirts * 1 : 0
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
# VOUCHER_PROMO = BuyXGetOneFree.new "VOUCHER", 1
