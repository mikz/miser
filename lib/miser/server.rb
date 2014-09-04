require 'sinatra'

module Miser
  class Server < Sinatra::Base
    set(:store, Miser::SecureStore.new)
    enable :inline_templates

    get '/' do
      erb settings.store.status
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
<p>Your miser is locked. Please enter password.</p>

@@ unlocked
<p>Your miser is unlocked.</p>
