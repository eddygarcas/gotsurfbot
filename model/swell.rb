require_relative '../utils/data_builder'

class Swell
  include DataBuilder

  def initialize elem
    parse elem unless elem.nil?
  end

  def type
    'article'
  end

  def title
    "Date #{date} at #{hour}h"
  end

  def description
    %Q{#{swell["category"]} Swell #{swell["height"]}}
  end

  def thumb_url
    "https://www.fnmoc.navy.mil/wxmap_cgi/dynamic/N3_COAMPS_WMED/2020060300/n3_coamps_wmed10.sgwvht.0#{graph_hour 3}.wmed.gif"
  end

  def to_inline_button

  end

  def to_s
    %Q{#{swell["category"]} Swell #{swell["height"]}#{swell["unit"]} T(p) #{swell["period"]}s #{swell["direction"]} #{wind["category"]} #{wind["speed"]}#{wind["unit"]} #{wind["direction"]}}
  end

  def to_html
    %Q{<b>#{flag}#{city} #{date} at #{hour}h</b><pre>#{swell["category"]} <b>Swell</b> #{swell["height"]}#{swell["unit"]} T(p)#{swell["period"]}s Dir.#{swell["direction"]}#{swell["icon"]}\n#{wind["category"]} <b>Wind</b> #{wind["speed"]}#{wind["unit"]} Dir.#{wind["direction"]}#{wind["icon"]}</pre><a href='#{thumb_url}'>Chart</a>}
  end

  private

  def parse elem
    (elem.keys).uniq.each {|key|
      v = nested_hash_value(elem, key)
      accesor_builder key, v
    }
  end

  def graph_hour divs = 6
    h = (check_date + hour.to_i).divmod(divs)[0]*divs
    return "0#{h}" if h < 10
    h
  end

  def check_date
    case DateTime.new(*date.split("-").reverse.map(&:to_i))
    when (Date.today + 1)
      return 24
    when (Date.today + 2)
      return 48
    else
      return 0
    end
  end

end
