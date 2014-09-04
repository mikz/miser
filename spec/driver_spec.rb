require 'miser/driver'

describe Miser::Driver do
  it { is_expected.to be }

  it 'has evo' do
    expect(subject['evo']).to be(Miser::Driver::EvoBanco)
    expect(subject['evo_banco']).to be(Miser::Driver::EvoBanco)
  end

  it 'has sabadell' do
    expect(subject['sabadell']).to be(Miser::Driver::BancSabadell)
    expect(subject['banc_sabadell']).to be(Miser::Driver::BancSabadell)
    expect(subject['bs']).to be(Miser::Driver::BancSabadell)
  end

  it 'raises on unknown driver' do
    expect{ subject['unknown'] }.to raise_error
  end
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
