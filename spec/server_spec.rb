require 'miser'

describe Miser::Server do
  include Rack::Test::Methods
  subject(:app) { described_class }

  it { is_expected.to be }


  context '/' do
    it 'works' do
      get '/'
      expect(last_response).to be_ok
    end
  end
end
