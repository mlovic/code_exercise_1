class UnknownProductError < StandardError
  attr_accessor :code

  def initialize(code = nil)
    super("Unknown product with code \"#{code}\"")
    self.code = code
  end
end

class Checkout
  # Also could have used *rules to take variable number of arguments 
  # instead of array.
  def initialize(rules=nil) 
    @rules = rules
    @items = {}
  end

  def scan(code)
    # This would normally go in some other class responsible for managing products
    raise UnknownProductError.new(code) unless product_codes.include?(code)
    @items[code] ? @items[code] += 1 : @items[code] = 1
  end

  def total
    subtotal = 
      @items.reduce(0) do |sum, (item, quant)|
        sum + (prices[item] * quant)
      end
    
    # TODO build discounts hash to use for reporting later
    discount = 
      @rules.reduce(0) do |sum, rule|
        sum += rule.apply_discount(@items, prices)
      end

    # An "actual" discount is a positive value
    subtotal - discount
  end

  private

    def prices
      @prices ||= 
        products.each_with_object({}) do |prod, hash|
          code = prod[:code]
          hash[code] = prod[:price]
        end
    end

    def products
      PRODUCTS
    end

    def product_codes
      @product_codes ||= products.map { |prod| prod[:code] }
    end
end
