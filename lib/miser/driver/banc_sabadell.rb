require 'miser/driver'

module Miser
  module Driver
    class BancSabadell < Miser::Driver::Base
      def login(nif, pin)
        @session.visit('https://www.bancsabadell.com/txbs/ChangeLocale.init.bs?locale=CAS')

        @session.fill_in("NIF", with: nif)
        @session.fill_in("pin", with: pin)

        @session.click_on('Entrar')
      end

      def parse_movements
        @session.all('table.sorted > tbody > tr').map do |row|
          fragment = Nokogiri::HTML::DocumentFragment.parse(row['innerHTML'].strip)

          amount = fragment.css('td[headers=amount]').attribute('title')
          date = fragment.css('td[headers=date]').attribute('abbr')
          purpose = fragment.css('td[headers=purpose]')

          Miser::Movement.new(
              date: DateTime.strptime(date.value, '%y%m%d%H%M%S'),
              amount: amount.value.to_f,
              purpose: purpose.text
          )
        end
      end

      def movements(date)
        @session.click_on('Saldo y extracto cuentas')

        @session.fill_in('dateMovFrom.day', with: date.day)
        @session.fill_in('dateMovFrom.month', with: date.month)
        @session.fill_in('dateMovFrom.year', with: date.year)
        @session.fill_in('CUExtractOperationsQuery.paginationRows', with: 100)

        # select the date period choice
        @session.find('input[type="radio"][name="r1"][value="2"]').click

        @session.click_on('Aceptar')

        parse_movements
      end
    end
  end
end
