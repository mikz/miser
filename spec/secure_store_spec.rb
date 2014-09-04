require 'miser'

describe Miser::SecureStore do

  it { is_expected.to be_locked }
  it { expect(subject.state).to be(:locked) }

  context 'after setting passphrase' do
    before { subject.passphrase = 'fake' }

    it { is_expected.to be_unlocked }
    it { expect(subject.state).to be(:unlocked) }
  end
end
