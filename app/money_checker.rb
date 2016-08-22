require './app/errors'

class MoneyChecker
  def initialize(allowed = [1, 2, 5, 10, 25, 50])
    @allowed = allowed
  end

  def validate(money)
    money.each do |coin, _|
      raise Errors::InappropriateMoney unless allowed.include?(coin.to_i)
    end
    true
  end

  private

  attr_reader :allowed
end
