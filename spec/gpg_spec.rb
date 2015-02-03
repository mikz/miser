require 'miser/gpg'

describe Miser::GPG do
  subject(:gpg) { described_class.new }

  context '#batch_script with passphrase' do
    subject(:batch_script) { gpg.batch_script(Passphrase: 'abc') }

    it { is_expected.to match(/^Passphrase: abc$/) }
    it { is_expected.to start_with('Key-Type: DSA') }
  end

  context 'key generation' do
    # cached version because key generation is expensive
    gpg = described_class.new

    before(:all) { expect(gpg.generate).to be }

    context 'public_key' do
      subject(:public_key) { gpg.public_key }


      it { is_expected.to start_with('-----BEGIN PGP PUBLIC KEY BLOCK-----')}
      it { is_expected.to end_with('-----END PGP PUBLIC KEY BLOCK-----')}
    end

    context 'private_key' do
      subject(:public_key) { gpg.private_key }

      it { is_expected.to start_with('-----BEGIN PGP PRIVATE KEY BLOCK-----')}
      it { is_expected.to end_with('-----END PGP PRIVATE KEY BLOCK-----')}
    end
  end

end
