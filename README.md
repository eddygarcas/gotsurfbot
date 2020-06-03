# GotSurfBot

Shows surf forecasts feeding from GotSurf Service.

# Ruby gems

The file *got_surf_bot.rb* requires Telegram Bot

    require 'telegram/bot'

#### Versions

    gem 'telegram-bot-ruby', '~>0.12.0'
    
### Procfile

In order to run this application in Heroku must include a Procfile adding the following config line

    Web: bundle exec ruby got_surf_bot.rb

### Usage

Before starting this app in Heroku it's required adding several environment variables. 
First one would be the Telegram Token string generated at creating the bot as well as other API token you need.

Once Telegram token has been acuired, add a environment variable:

    $ export TELEGRAM_TOKEN = <token by telegam> 

The last two ones are provided by https://github.com/eddygarcas which are the endpoint for the services as well as an access token.

    $ export GOT_SURF_SERVICE = <endpoint service url>
    $ export SERVICE_TOKEN = <service access token>
 
 Use the source command on every export if you want to load them as part of the shell session
 
    $ source ~/.bashrc  

