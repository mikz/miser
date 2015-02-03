require 'miser/version'

module Miser
  autoload :Report, 'miser/report'
  autoload :App, 'miser/app'
  autoload :Driver, 'miser/driver'
  autoload :SecureStore, 'miser/secure_store'
  autoload :KeyStore, 'miser/key_store'
  autoload :Credentials, 'miser/credentials'
  autoload :GPG, 'miser/gpg'
  autoload :Database, 'miser/database'
end
