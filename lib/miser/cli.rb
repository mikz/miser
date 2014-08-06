require 'thor'
require 'miser/driver/banc_sabadell'

begin
  require 'pry'
rescue LoadError
end

module Miser
  class CLI < Thor
    DATE_FORMAT = '%Y-%m-%d'.freeze

    desc 'check DRIVER *LOGIN', 'check account with DRIVER'
    option :days, desc: 'how many days back check', required: true, type: :numeric, default: 1
    def check(driver, *login)
      driver = Miser::Driver[driver].new

      driver.login(*login)
      movements = driver.movements(date)

      movements.select!{ |m| m.days_from_now < days && m.debit? }

      if movements.empty?
        puts 'No movements.'
        return
      end

      puts "Movements:"
      puts movements
      puts
      puts "Total Spent: #{movements.reduce(:+).abs}"
      binding.pry
    end

    private

    def days
      options[:days].to_f
    end

    def date
      DateTime.now - options[:days]
    end

    def now
      DateTime.now
    end
  end
end
