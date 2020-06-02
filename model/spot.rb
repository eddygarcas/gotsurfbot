require_relative '../utils/data_builder'

class Spot
  include DataBuilder

  def initialize elem
    parse elem unless elem.nil?
  end

  def type
    'article'
  end

  def title
    "#{flag} #{city.capitalize}"
  end

  def description
    %Q{}
  end

  def thumb_url
    ''
  end

  def to_inline_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: city.capitalize, switch_inline_query_current_chat: point)
  end

  def to_s
    %Q{Click here to share #{city} button on current chat}
  end

  def to_html
    %Q{Click button below 👇 to see #{city.capitalize} Surf forecast}
  end

  private

  def parse elem
    (elem.keys).uniq.each {|key|
      v = nested_hash_value(elem, key)
      accesor_builder key, v
    }
  end

end
