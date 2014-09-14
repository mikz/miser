require 'sinatra'
require 'miser/database'

module Miser
  class App < Sinatra::Base
    set :store, Miser::SecureStore.new(Miser::KeyStore)

    enable :inline_templates
    disable :show_exceptions

    def store
      settings.store
    end

    get '/' do
      @drivers = ['sabadell', 'evo']
      @credentials = Credentials.all
      erb store.state
    end

    post '/unlock' do
      store.passphrase = params[:passphrase]
      redirect '/'
    end

    post '/check/:driver' do
      creds = Credentials.with_pk!(params[:driver])
      creds.decrypt(store)

      driver = Miser::Driver.new(creds.driver)
      driver.login(*creds.credentials)

      movements = driver.movements(DateTime.now - 1)
      movements.to_s
    end

    post '/credentials' do
      halt(403) unless store.unlocked?
      credentials = Credentials.new(params)
      credentials.encrypt(store) ? redirect('/') : halt(412)
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
<p>
<% @credentials.each do |cred| %>
 <form action='/check/<%= cred.driver %>' method=post>
  <button>Check <%= cred.driver %></button>
 </form>
<% end %>
<form action='/credentials' method='post'>
<select name='driver'>
<% @drivers.each do |driver| %>
<option value='<%= driver %>'><%= driver %></option>
<% end %>
</select>
<input type='text' name='username'/>
<input type='password' name='password'/>
<input type=submit>
</form>
</p>
