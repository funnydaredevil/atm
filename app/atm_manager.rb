class AtmManager
  include Singleton

  def initialize_atm(money)
    @atm ||= Atm.new(money)
  end

  attr_accessor :atm
end
