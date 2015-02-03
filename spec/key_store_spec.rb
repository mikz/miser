describe Miser::KeyStore do
   it { expect(described_class).to be }

   context 'gpg key' do
     let(:gpg) { Miser::GPG.new }

     before { expect(gpg.generate).to be }

     subject(:key) { described_class.import(gpg) }

     it 'imports key with id' do
       expect(key.key_id).to match(/^[A-Z0-9]{16}$/)
     end
   end

 end
