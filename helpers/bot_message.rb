require_relative 'config_helper'

class BotMessage < ConfigHelper

  def self.send_bot_response(bot, chatId, markup = nil, text = nil)
    if text.nil?
      bot.api.send_message(chat_id: chatId,text: %Q{#{get_text_message(:start)}},reply_markup: markup)
    elsif markup.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{#{text}})
    else
      bot.api.send_message(chat_id: chatId,text: %Q{#{text}},reply_markup: markup)
    end
  end

  def self.send_query_response(bot, chatId, item = nil, inline = false)
    if item.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{#{get_text_message(:error)}})
    else
      send_location(bot, chatId, item, inline)
    end
  end


  protected

  def self.send_location(bot, chatId, item, inline = false)
    if inline
      send_inline_location(bot, chatId, item)
    else
      send_callback_location(bot, chatId, item)
    end
  end

  private

  def self.send_inline_location(bot, chatId, item)
    bot.api.answer_inline_query(
        inline_query_id: chatId,
        results: inline_result(item),
        cache_time: 10,
        is_personal: true
    )
  end

  def self.send_callback_location(bot, chatId, item)
    bot.api.send_venue(chat_id: chatId,
                       latitude: item.latitude,
                       longitude: item.longitude,
                       title: item.name,
                       address: item.to_string
    )
  end

  def self.inline_result(item)
    result = []
    if arr = Array.try_convert(item)
      count = 0
      result = arr.map {|elem| create_inline_result(elem, count+=1)}
    else
      result << create_inline_result(item)
    end
    result
  end

  private

  def self.create_inline_result(item, count = 1)
    Telegram::Bot::Types::InlineQueryResultArticle.new(
        type: 'article',
        id: count.to_s,
        thumb_url: item.thumb_url,
        title: item.title,
        description: item.to_s,
        input_message_content: text_message(item),
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: item.to_inline_button)
    )
  end

  def self.text_message(item)
    Telegram::Bot::Types::InputTextMessageContent.new(
        message_text: item.to_html,
        parse_mode: 'HTML',
        disable_web_page_preview: false
    )
  end
end
