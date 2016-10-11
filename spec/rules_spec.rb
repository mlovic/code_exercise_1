require_relative '../lib/rules'

RSpec.describe PricingRule do
  it 'raises error unless initializer receives a block' do
    expect { PricingRule.new }.to raise_error(ArgumentError)
  end

  it 'calls the block when apply_rule method is called' do
    block = Proc.new {}
    rule = PricingRule.new(&block)
    expect(block).to receive(:call)
    rule.apply_discount nil, nil 
  end
end

RSpec.describe STRAWBERRIES_BULK_PROMO do
  let(:prices) { {'SR1' => 25} }

  it 'offers no discount if there are less than 3 tshirts' do
    items = {'SR1' => 2}
    expect(STRAWBERRIES_BULK_PROMO.apply_discount(items, prices)).to eq 0
  end

  it 'offers discount on all tshirts when there are 3 or more tshirts' do
    items = {'SR1' => 3}
    expect(STRAWBERRIES_BULK_PROMO.apply_discount(items, prices)).to eq 3
  end

  it 'offers discount on only tshirts' do
    items = {'SR1' => 2, 'MUG' => 4}
    expect(STRAWBERRIES_BULK_PROMO.apply_discount(items, prices)).to eq 0
  end
end

RSpec.describe GREEN_TEA_PROMO do
  let(:prices) { {'GR1' => 5} }

  it 'offers no discount if only one voucher is present' do
    items = {'GR1' => 1}
    expect(GREEN_TEA_PROMO.apply_discount(items, prices)).to eq 0
  end

  it 'subtracts the price of only one discount if 3 vouchers are present' do
    items = {'GR1' => 3}
    expect(GREEN_TEA_PROMO.apply_discount(items, prices)).to eq 5
  end
end
