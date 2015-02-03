require 'miser/database'
require 'json'

module Miser
  class Credentials < Sequel::Model
    plugin :validation_helpers
    unrestrict_primary_key
    self.raise_on_save_failure = false

    attr_writer :username, :password

    def encrypt(store)
      creds = JSON.generate([@username, @password])

      values[:credentials] = store.encrypt(creds)
      values[:key_id] = store.key_id

      save
    end

    def decrypt(store)
      credentials = store.decrypt(this, :credentials)
      values[:credentials] = JSON.parse(credentials)
    end

    def validate
      super
      validates_presence :credentials
      validates_presence :key_id
      validates_unique :driver
    end

  end
end

