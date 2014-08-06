require 'capybara'
require 'miser'
require 'miser/movement'
require 'capybara/selenium/driver'

module Miser
  module Driver

    def self.[](name)
      case name
        when 'banc_sabadell'
          Miser::Driver::BancSabadell
      end
    end

    class Base
      DEFAULT_BROWSER = :chrome

      def initialize
        @session = Capybara::Session.new(browser)
      end

      def browser
        DEFAULT_BROWSER
      end

      def login(*args)
      end

      def movements
      end
    end
  end
end
