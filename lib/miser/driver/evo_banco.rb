require 'miser/driver'

module Miser
  module Driver
    class EvoBanco < Miser::Driver::Base

      def login(card_number, pin)
        @session.visit('https://bancaelectronica.evobanco.com/')

        @session.fill_in('card01', with: card_number)
        @session.find('#pin_number').click
        keyboard = @session.find('.virtual_keyboard')
        pin.split('').each do |number|
          keyboard.find('a', text: number).click
        end
        @session.click_on('Accept')
      end


      def movements(date)
        @session.click_on('Accounts')
        @session.click_on('Movements')
        @session.click_on('Search for more movements')

        @session.select date.day.to_s.rjust(2,'0'), from: 'ctl00$ctl00$ctl00$CuerpoPlaceHolder$CuerpoOperacionPlaceHolder$ContenidoOperacionPlaceHolder$fechas$fromdays'
        @session.select date.month.to_s.rjust(2,'0'), from: 'ctl00$ctl00$ctl00$CuerpoPlaceHolder$CuerpoOperacionPlaceHolder$ContenidoOperacionPlaceHolder$fechas$frommonth'
        @session.select date.year, from: 'ctl00$ctl00$ctl00$CuerpoPlaceHolder$CuerpoOperacionPlaceHolder$ContenidoOperacionPlaceHolder$fechas$fromyears'
        @session.click_on('Search')

        parse_movements
      end


      def parse_movements
        @session.all('table.movements > tbody > tr').map do |row|
          fragment = Nokogiri::HTML::DocumentFragment.parse(row['innerHTML'].strip)
          div = fragment.css('td div')

          date = div.text.match(/Transaction date: (.{19})/)[1]
          purpose = div.css('a')
          amount, _balance = fragment.css('td > span[id] > span[id]')

          Movement.new(
              date: DateTime.strptime(date, '%d/%m/%Y %H:%M:%S'),
              amount: amount.text.to_f,
              purpose: purpose.text
          )
        end
      end
    end
  end
end
