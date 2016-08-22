require 'spec_helper'
RSpec.describe MoneyChecker do
  let(:allowed) { [1, 2, 5, 10, 25, 50] }

  describe '.initialize' do
    it 'initializes a new money_checker' do
      expect(described_class.new(allowed)).to be_instance_of MoneyChecker
    end
  end

  let(:money_checker) { described_class.new(allowed) }

  describe '#validate' do
    it 'responds to validate' do
      expect(money_checker).to respond_to(:validate)
    end

    let(:money_to_validate) { { 50 => 3, 25 => 2 } }
    it 'return true for valid coins' do
      expect(money_checker.validate(money_to_validate)).to be_truthy
    end

    let(:invalid_coins) { { 100 => 30 } }
    it 'raises an error InappropriateMoney with invalid coins' do
      expect { money_checker.validate(invalid_coins) }
        .to raise_error(Errors::InappropriateMoney)
    end
  end
end
