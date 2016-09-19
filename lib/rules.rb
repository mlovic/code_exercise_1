class PricingRule
  def initialize(name = nil, &block)
    raise ArgumentError, "Rule must be initialized with a block" unless block_given?
    @name = name
    @operation = block
  end

  def apply_discount items, prices
    @operation.call items, prices
  end
end

VOUCHER_PROMO = 
  PricingRule.new("Summer voucher promotion") do |items, prices|
    (items["VOUCHER"] / 2) * prices["VOUCHER"]
  end

TSHIRT_BULK_PROMO = 
  PricingRule.new do |items, prices|
    num_tshirts = items["TSHIRT"]
    num_tshirts >= 3 ? num_tshirts * 1 : 0
  end
