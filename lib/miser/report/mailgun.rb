require 'mailgun'

module Miser
  class Report
    class Mailgun

      def initialize(api_key, from, to)
        @client = ::Mailgun::Client.new(api_key)
        @to = to
        @from = from
        @domain = from.split('@').last
      end

      def deliver(report)
        params = {
            from: "Miser <postmaster@#{@domain}>",
            to: @to,
            subject: report.subject,
            text: report.text
        }

        @client.send_message(@domain, params)
      end
    end
  end
end
