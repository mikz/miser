require 'miser/driver'

describe Miser::Driver do
  it { is_expected.to be }
end

describe Miser::Driver::Base do
  it { is_expected.to be }
  subject(:driver) { described_class.new }

  context '#session' do
    subject(:session) { driver.session }

    it { is_expected.to be_a(Capybara::Session) }

    it 'visits google.com' do
      page = session.visit('https://google.com')
      expect(page).to eq('status' => 'success')
    end
  end
end
