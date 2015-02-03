require 'miser'

describe Miser::SecureStore do
  let(:key_store) { Miser::KeyStore }
  let(:key) { class_double(key_store) }
  subject(:secure_store) { described_class.new(key) }

  it { is_expected.to be_locked }
  it { expect(subject.state).to be(:locked) }

  context 'after setting passphrase' do
    before { subject.passphrase = 'fake' }

    it { is_expected.to be_unlocked }
    it { expect(subject.state).to be(:unlocked) }
  end

  context 'without keys' do
    let(:key) { class_double(key_store, empty?: true) }

    it { is_expected.to be_empty }

    context 'with keys' do
      let(:key) { class_double(key_store, empty?: false) }
      it { is_expected.not_to be_empty}
    end
  end
end
