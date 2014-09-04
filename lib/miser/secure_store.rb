module Miser
  class SecureStore
    def initialize
      @unlocked = false
    end

    def passphrase=(passphrase)
      @unlocked = true
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
