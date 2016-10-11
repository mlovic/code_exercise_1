require_relative '../lib/rules'
require_relative '../lib/checkout'

  PRODUCTS = [{code: 'GR1', price: 3.11},
              {code: 'SR1', price: 5.0},
              {code: 'CF1', price: 11.23}]

RSpec.describe 'Exercise example' do
  let(:pricing_rules) { [GREEN_TEA_PROMO, STRAWBERRIES_BULK_PROMO] }
  let(:co) { Checkout.new(pricing_rules) }

  it 'returns the correct price' do
    pricing_rules = [GREEN_TEA_PROMO, STRAWBERRIES_BULK_PROMO]
    co = Checkout.new(pricing_rules)
    co.scan("GR1")
    co.scan("GR1")
    co.scan("SR1")
    price = co.total
    expect(price).to eq 8.11
  end

  # Other examples from exercise
  it 'example 1' do
    items = %W(GR1 SR1 GR1 GR1 CF1)
    items.each { |i| co.scan i }
    expect(co.total).to eq 22.45
  end

  it 'example 2' do
    items = %W(GR1 GR1)
    items.each { |i| co.scan i }
    expect(co.total).to eq 3.11
  end

  it 'example 3' do
    items = %W(SR1 SR1 GR1 SR1)
    items.each { |i| co.scan i }
    expect(co.total).to eq 16.61
  end
end

