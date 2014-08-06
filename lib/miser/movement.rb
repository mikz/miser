module Miser
  class Movement
    attr_reader :date, :amount, :purpose

    ZERO = 0.0

    def initialize(date:, amount:, purpose:)
      @date = date
      @amount = amount
      @purpose = purpose
    end

    def +(amount)
      @amount + amount
    end

    def debit?
      @amount < ZERO
    end

    def credit?
      @amount > ZERO
    end

    def coerce(numeric)
      [@amount, numeric]
    end

    def to_s
      "#{@date}: #{@amount} (#{@purpose})"
    end

    def days_from_now
      (DateTime.now - @date).to_f
    end
  end
end
