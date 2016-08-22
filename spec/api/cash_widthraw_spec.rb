require 'spec_helper'

describe CashWidthraw::API do
  include Rack::Test::Methods

  def app
    CashWidthraw::API
  end

  before do
    money = { 1 => 10, 2 => 10, 5 => 10, 10 => 10, 25 => 10, 50 => 3 }

    atm = AtmManager.instance.initialize_atm(money)
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:atm).and_return(atm)
    end
  end

  context 'GET /atm' do
    it 'widthraws 200 coins from atm' do
      get '/atm/200'
      expect(last_response.status).to eq(200)
      response = IndifferentHash.new('50': 3, '25': 2)
      expect(JSON.parse(last_response.body)).to eq response
    end

    it 'returns error message that atm hasn\'t enough money' do
      get '/atm/200000'
      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body))
        .to eq('message' => 'ATM haven\'t enough money')
    end
  end

  context 'GET /atm' do
    it 'refills coins in ATM' do
      post '/atm', 'money': { 1 => 10 }
      expect(last_response.status).to eq(201)
      response = IndifferentHash.new(
        '1' => 20, '2' => 10, '5' => 10, '10' => 10, '25' => 8, '50' => 0
      )
      expect(JSON.parse(last_response.body)).to eq response
    end

    it 'returns error message about refilling with corrupted money' do
      post '/atm', 'money': { 1 => 10, 123 => 1 }
      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body))
        .to eq('message' => 'Failed to refill ATM with corrupted coins')
    end
  end
end
