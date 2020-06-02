require_relative '../comms/got_surf_service'
require_relative 'config_helper'

class BotHelper < ConfigHelper

  def self.get(data = 'Barcelona')
    location = config(:spots)[data.to_s.downcase]
    fields = config(:fields)
    MswHttpSearch.new.get_spot(location, fields)
  end

  def self.bot_markup
    kb = [[Telegram::Bot::Types::KeyboardButton.new(text: 'Start'), Telegram::Bot::Types::KeyboardButton.new(text: 'Help')]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_spots_markup)
  end

  private

  def self.inline_spots_markup
    keyboard_spots = Array.new(4) { Array.new }
    GotSurfService.new.get_spots.each_with_index{ |elem,index|
      keyboard_spots[index.divmod(2)[0]] << elem.to_inline_button
    }
    keyboard_spots
  end

end

