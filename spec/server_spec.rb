require 'miser'

describe Miser::Server do
  include Rack::Test::Methods
  subject(:app) { described_class }

  it { is_expected.to be }

  it 'has same store' do
    expect(app.store).to be(app.store)
  end

  context '/' do
    it 'works' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response).to match(/Please enter the password/)
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
