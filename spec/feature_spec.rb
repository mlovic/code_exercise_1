require_relative '../lib/rules'
require_relative '../lib/checkout'


RSpec.describe 'Exercise example' do
  PRODUCTS = [{code: 'VOUCHER', price: 5.0},
              {code: 'TSHIRT' , price: 20.0},
              {code: 'MUG'    , price: 7.5}]
  let(:pricing_rules) { [VOUCHER_PROMO, TSHIRT_BULK_PROMO] }
  let(:co) { Checkout.new(pricing_rules) }

  it 'returns the correct price' do
    pricing_rules = [VOUCHER_PROMO, TSHIRT_BULK_PROMO]
    co = Checkout.new(pricing_rules)
    co.scan("VOUCHER")
    co.scan("VOUCHER")
    co.scan("TSHIRT")
    price = co.total
    expect(price).to eq 25
  end

  it 'other exercises' do
    puts 'now'
    #items = %W(TSHIRT TSHIRT TSHIRT VOUCHER TSHIRT)
    items = %W(VOUCHER TSHIRT VOUCHER VOUCHER MUG TSHIRT TSHIRT)

    items.each { |i| co.scan i }
    expect(co.total).to eq 74.5
  end
end

