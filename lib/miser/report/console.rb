module Miser
  class Report
    class Console
      def deliver(report)
        puts report.subject
        puts
        puts report.text
      end
    end
  end
end
