require_relative '../lib/checkout'

RSpec.describe Checkout do

  PRODUCTS = [{code: 'VOUCHER', price: 5.0},
              {code: 'TSHIRT' , price: 20.0},
              {code: 'MUG'    , price: 7.5}]

  describe "scan" do
    it "raises error if it doesn't recognize code" do
      co = Checkout.new
      expect { co.scan("WRONG_CODE") }.to raise_error(UnknownProductError)
    end
  end

  describe "total" do
    let(:rule1) { double("rule1") }
    let(:rule2) { double("rule2") }
    let(:co)    { Checkout.new [rule1, rule2] }

    it "applies all rules" do
      expect(rule1).to receive(:apply_discount).and_return 1
      expect(rule2).to receive(:apply_discount).and_return 2
      co.total
    end

    it "subtracts sum of discounts from subtotal" do
      allow(rule1).to receive(:apply_discount).and_return 1
      allow(rule2).to receive(:apply_discount).and_return 2
      co.scan("VOUCHER")
      expect(co.total).to eq 2
    end
      
  end
end
