require 'capybara'
require 'miser'
require 'miser/movement'
require 'capybara/poltergeist'

module Miser
  module Driver
    autoload :BancSabadell, 'miser/driver/banc_sabadell'
    autoload :EvoBanco, 'miser/driver/evo_banco'

    Capybara.default_wait_time = 30

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app,
                                        js_errors: false,
                                        phantomjs_options: %w[--ignore-ssl-errors=no])
    end

    def self.[](name)
      case name
        when 'banc_sabadell', 'sabadell', 'bs'
          Miser::Driver::BancSabadell
        when 'evo_banco', 'evo'
          Miser::Driver::EvoBanco
        else
          raise "unknown driver '#{name}'"
      end
    end

    class Base
      DEFAULT_BROWSER = :poltergeist
      attr_reader :session

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
