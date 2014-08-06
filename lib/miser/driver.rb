require 'capybara'
require 'miser'
require 'miser/movement'
require 'capybara/selenium/driver'

module Miser
  module Driver

    Capybara.register_driver(:firefox) do |app|
      Capybara::Selenium::Driver.new(app, browser: :firefox)
    end

    Capybara.register_driver(:chrome) do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome, switches: %w[--test-type])
    end

    def self.[](name)
      case name
        when 'banc_sabadell', 'sabadell'
          Miser::Driver::BancSabadell
        when 'evo_banco', 'evo'
          Miser::Driver::EvoBanco
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
