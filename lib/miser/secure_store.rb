module Miser
  class SecureStore
    def initialize
      @unlocked = false
    end

    def locked?
      !@unlocked
    end

    def status
      locked? ? :locked : :unlocked
    end
  end
end
