module Miser
  class Report
    autoload :Mailgun, 'miser/report/mailgun'
    autoload :Console, 'miser/report/console'

    def initialize(movements, date)
      @movements = movements
      @date = date
    end

    def total_spent
      total.abs
    end

    def subject
      "Miser report for #{@date.to_date}"
    end

    def text
<<-TEXT
Total Spent: #{total_spent}

#{@movements.join("\n")}
TEXT
    end

    private
    def total
      @movements.reduce(:+) || 0
    end
  end

end
