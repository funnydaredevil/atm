require './app/money_checker'
require './app/errors'
require './lib/indifferent_hash'
class Atm
  def initialize(money)
    money_checker.validate(money)
    @money = IndifferentHash.new(money)
  end

  def widthraw(sum)
    select_coins(sum)
  end

  def refill(money_to_refill)
    money_checker.validate(money_to_refill)
    money.merge!(money_to_refill) do |_, balance, refill|
      balance + refill.to_i
    end
  end

  private

  attr_accessor :money

  def sort_money(money_to_sort)
    money_to_sort.sort_by { |key, _| key.to_i }.reverse.to_h
  end

  def money_checker
    @money_checker ||= MoneyChecker.new([1, 2, 5, 10, 25, 50])
  end

  # Method has high assignment branch condition size.
  # Could be Extracted to separate class AtmCashbackCalculator
  def select_coins(sum)
    cashback = {}
    sort_money(money).each do |coin_string, amount|
      coin = coin_string.to_i
      refill = coin * amount > sum ? sum.div(coin) : amount
      if refill.nonzero?
        money[coin] = money[coin] - refill
        cashback[coin] = refill
        sum -= coin * refill
      end
      return cashback if sum.zero?
    end
    refill(cashback)
    raise Errors::NotEnoughFunds
  end
end
