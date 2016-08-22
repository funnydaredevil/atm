require_relative './api/cash_widthraw'

money = { 1 => 10, 2 => 10, 5 => 10, 10 => 10, 25 => 10, 50 => 3 }

AtmManager.instance.initialize_atm(money)

run CashWidthraw::API
