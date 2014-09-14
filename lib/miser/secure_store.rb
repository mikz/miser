module Miser
  class SecureStore

    def initialize(key_store)
      @key_store = key_store
      @unlocked = false
    end

    def passphrase=(passphrase)
      @unlocked = true
      @passphrase = passphrase
      # db[:store].select{ Sequel.function(:pgp_pub_encrypt, 'text', Sequel.function(:dearmor, 'key')) }.sql
    end

    def key_id
      @key_store.key_id
    end

    def encrypt(data)
      Sequel.function(:pgp_pub_encrypt, data, @key_store.public_key)
    end

    def decrypt(dataset, column)
      decryptor = Sequel.function(:pgp_pub_decrypt, :credentials, :private_key, Sequel.expr(@passphrase).cast(:text))
      dataset
        .join(:key_store, [:key_id])
        .select(Sequel.as(decryptor, column)).first.fetch(column)
    end

    def locked?
      !@unlocked
    end

    def unlocked?
      @unlocked
    end

    def state
      locked? ? :locked : :unlocked
    end
  end
end
