require 'thor'
require 'miser'
require 'miser/driver/banc_sabadell'
require 'miser/driver/evo_banco'
require 'rufus-scheduler'

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
      console = Miser::Report::Console.new
      movements = movements(driver, *login)
      report = Miser::Report.new(movements, date)
      console.deliver(report)
    end

    option :api_key, desc: 'Mailgun API key', required: true
    option :to, desc: 'email address', required: true
    option :from, desc: 'email address', required: true
    option :days, desc: 'how many days back check', required: true, type: :numeric, default: 1
    desc 'report DRIVER *LOGIN', 'check your account and deliver the report to email'
    def report(driver, *login)
      mail = Miser::Report::Mailgun.new(options[:api_key], options[:from], options[:to])
      movements = movements(driver, *login)
      report = Miser::Report.new(movements, date)
      mail.deliver(report)
    end

    desc 'interactive', 'run interactive mode'
    option :echo, type: :boolean, desc: 'no echo mode', default: false
    def interactive
      puts "Please enter what to run and press enter:"
      mode = options[:echo] ? :cooked : :noecho
      command = STDIN.send(mode, &:gets).strip
      puts
      cmd = "#{Process.argv0} #{command}"
      exec cmd
    end

    desc 'schedule TIME *ARGS', 'schedule check every TIME'
    def schedule(time, *args)
      hour, minute = time.split(':')
      scheduler = Rufus::Scheduler.new

      line = "#{minute || '*'} #{hour || '*'} * * *"
      scheduler.cron line do
        system(Process.argv0, *args)
      end

      Process.setproctitle "miser schedule #{line}"
      puts "Scheduled to be executed every #{line}"

      scheduler.join
    end

    private

    def movements(driver, *login)
      driver = Miser::Driver[driver].new
      driver.login(*login)

      movements = driver.movements(date)
      movements.select{ |m| m.days_from_now < days && m.debit? }
    end


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
