require 'miser/database'

module Miser
  class KeyStore < Sequel::Model(:key_store)
    unrestrict_primary_key
    plugin :validation_helpers

    module StoreMethods
      extend Forwardable
      def_delegators :first!, :public_key, :private_key, :key_id
    end

    extend(StoreMethods)

    def self.dearmor(key)
      Sequel.function(:dearmor, key)
    end

    def self.pgp_key_id(key)
      Sequel.function(:pgp_key_id, key)
    end

    def self.import(gpg)
      key = new(private_key: dearmor(gpg.private_key),
                public_key: dearmor(gpg.public_key))

      key.values[:key_id] = pgp_key_id(key.public_key)
      key.save
      key
    end

    def validate
      super
      validates_presence :private_key
      validates_presence :public_key
      validates_unique :key_id
    end

  end
end
