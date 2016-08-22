require 'pry'
require 'grape'
require './app/atm'
require './app/atm_manager'

module CashWidthraw
  class API < Grape::API
    version 'v1', using: :header, vendor: 'atm'
    format :json

    helpers do
      def atm
        AtmManager.instance.atm
      end
    end

    resource :atm do
      desc 'Widthraw money in coins'
      params do
        requires :coins, type: Integer, desc: 'coins amount to widthraw'
      end
      route_param :coins do
        get do
          begin
            atm.widthraw(params[:coins])
          rescue => NotEnoughFunds
            error!({ message: 'ATM haven\'t enough money' }, 400)
          end
        end
      end

      desc 'Refill ATM'
      params do
        requires :money, type: Hash, desc: 'money to refill'
      end
      post do
        begin
          atm.refill(params[:money])
        rescue => InappropriateMoney
          error!({ message: 'Failed to refill ATM with corrupted coins' }, 400)
        end
      end
    end
  end
end
