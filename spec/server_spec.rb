require 'miser'
require 'spec_helper'
require 'rack/test'

describe Miser::App do
  include Rack::Test::Methods
  subject(:app) { described_class }

  it { is_expected.to be }

  it 'has same store' do
    expect(app.store).to be(app.store)
  end


  context '/' do

    it 'allows setup' do
      get('/')
    puts last_response.inspect
      expect(last_response).to be_redirect
      expect(last_response).to match(/Please set up your Miser with password:/)
    end

    context 'when set up' do

      before { app.store.setup('password') }

      it 'asks for password' do
        get('/')
        expect(last_response).to be_ok
      end
    end
  end

  context '/unlock' do
    let(:store) { instance_double(Miser::SecureStore) }
    before { allow(app.settings).to receive(:store).and_return(store) }

    it 'unlocks store' do
      expect(store).to receive(:passphrase=).with('fake')
      post '/unlock', passphrase: 'fake'
      expect(last_response).to be_redirect
    end

  end
end
