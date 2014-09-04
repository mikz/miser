require 'sinatra'
require 'sequel'

module Miser
  class Server < Sinatra::Base
    set :store, Miser::SecureStore.new
    set :database, Sequel.connect(ENV.fetch('DATABASE_URL', 'postgres://localhost/miser'))

    enable :inline_templates
    disable :show_exceptions

    def store
      settings.store
    end

    get '/' do
      erb store.state
    end

    post '/unlock' do
      store.passphrase = params[:passphrase]
      redirect '/'
    end
  end
end

__END__
@@ layout
<html>
  <head></head>
  <body><%= yield %></body>
</html>

@@ locked
<p>Your miser is locked. Please enter the password.</p>
<form action='/unlock' method=post>
<input type=password name=passphrase />
<input type=submit>
</form>

@@ unlocked
<p>Your miser is unlocked.</p>
