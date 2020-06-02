require 'httparty'
require_relative '../model/swell'
require_relative '../model/spot'

class GotSurfService
  include HTTParty

  format :json

  def get_spots
    self.class.base_uri ENV[:GOT_SURF_SERVICE.to_s]
    response = self.class.get('/spots', headers: {"Authorization" => "Bearer #{ENV[:SERVICE_TOKEN.to_s]}"})
    parse_response(response)
  end

  def get_swell(point)
    raise ArgumentError.new('Missing spot location') if point.nil?
    self.class.base_uri ENV[:GOT_SURF_SERVICE.to_s]
    response = self.class.get("/spots/#{point}", headers: {"Authorization" => "Bearer #{ENV[:SERVICE_TOKEN.to_s]}"})
    parse_response(response).take(50)
  end

  private

  def parse_response(response)
    data = []
    json_resp = JSON.parse(response.body)
    raise StandardError.new(json_resp["errors"]) if json_resp["errors"]
    parse_spot(json_resp){|e| data << e } if json_resp["spots"]
    parse_swell(json_resp){|e| data << e } if json_resp["spot"]
    data
  end

  def parse_spot json_resp
    json_resp["spots"]&.each do |spot|
      yield Spot.new(spot)
    end
  end

  def parse_swell json_resp
    json_resp["spot"]["swells"]&.each do |swell|
      yield Swell.new(swell)
    end
  end
end

