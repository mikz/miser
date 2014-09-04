module Miser
  class SecureStore
    def initialize
      @unlocked = false
    end

    def passphrase=(passphrase)
      @unlocked = true
      # db[:store].select{ Sequel.function(:pgp_pub_encrypt, 'text', Sequel.function(:dearmor, 'key')) }.sql
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
