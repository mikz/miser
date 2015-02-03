require 'sequel'
require 'logger'

module Miser
  database_url = ENV.fetch('DATABASE_URL', 'postgres://localhost/miser')
  Database = Sequel.connect(database_url, loggers: [Logger.new(STDERR)])
end
