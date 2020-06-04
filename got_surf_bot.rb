require 'telegram/bot'
require_relative 'helpers/bot_helper'
require_relative 'helpers/bot_message'
require_relative 'comms/got_surf_service'
#require_relative 'helpers/config_helper'


Telegram::Bot::Client.run(ENV[:TELEGRAM_TOKEN.to_s]) do |bot|
  bot.listen do |message|
    ConfigHelper.log(message)
    case message

    when Telegram::Bot::Types::InlineQuery
      items = GotSurfService.new.get_swell(message.query)
      BotMessage.send_message(bot, message.id, items, true)


    when Telegram::Bot::Types::Message
      if message.text.downcase.include? "help"
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, ConfigHelper.get_text_message(:help))
      end
      if message.text.downcase.include? "start"
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup)
      else
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup,ConfigHelper.get_bot_message(:list))
      end
    end
  end
end
