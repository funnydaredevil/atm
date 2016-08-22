require 'spec_helper'
RSpec.describe Atm do
  let(:fill_money) do
    {
      1 => 0,
      2 => 0,
      5 => 0,
      10 => 0,
      25 => 10,
      50 => 3
    }
  end

  describe '.initialize' do
    it 'initializes a new atm' do
      expect(described_class.new(fill_money)).to be_instance_of Atm
    end
  end

  let(:atm) { described_class.new(fill_money) }

  describe '#widthraw' do
    it 'responds to widthraw' do
      expect(atm).to respond_to(:widthraw)
    end

    let(:widthrawed_money) { { 50 => 3, 25 => 2 } }

    it 'widthraws 200 coins' do
      expect(atm.widthraw(200)).to eq widthrawed_money
    end

    let(:money_left) do
      IndifferentHash.new(
        1 => 0,
        2 => 0,
        5 => 0,
        10 => 0,
        25 => 8,
        50 => 0
      )
    end

    it 'reduces money amount after successfull widthraw' do
      atm.widthraw(200)
      expect(atm.send(:money)).to eq money_left
    end

    it 'raises an error NotEnoughFunds with twenty coins request' do
      expect { atm.widthraw(1_000_000) }.to raise_error(Errors::NotEnoughFunds)
    end

    let(:money_returned_to_atm) do
      IndifferentHash.new(
        1 => 0,
        2 => 0,
        5 => 0,
        10 => 0,
        25 => 10,
        50 => 3
      )
    end

    it 'leaves money in ATM after unsuccessfull widthraw' do
      expect { atm.widthraw(1_000_000) }.to raise_error(Errors::NotEnoughFunds)
      expect(atm.send(:money)).to eq money_returned_to_atm
    end

    it 'raises an error NotEnoughFunds with one million coins request' do
      expect { atm.widthraw(1_000_000) }.to raise_error(Errors::NotEnoughFunds)
    end
  end

  describe '#refill' do
    it 'responds to refill' do
      expect(atm).to respond_to(:refill)
    end

    let(:refill_money) do
      IndifferentHash.new(
        1 => 10,
        2 => 10,
        5 => 10,
        10 => 10,
        25 => 2,
        50 => 3
      )
    end

    let(:refilled_money) do
      IndifferentHash.new(
        1 => 10,
        2 => 10,
        5 => 10,
        10 => 10,
        25 => 12,
        50 => 6
      )
    end

    it 'refills 200 coins' do
      expect(atm.refill(refill_money)).to eq refilled_money
    end
  end
end
