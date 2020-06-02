require 'test/unit'
require_relative 'comms/got_surf_service'

class GotSurfBotTest < Test::Unit::TestCase
  def setup
    @@config = YAML.load_file 'config/config.yml'
  end

  def teardown
    # Do nothing
  end

  def test_get_spots
    spot = GotSurfService.new.get_spots
    assert_equal(spot[0].url,"http://localhost:5000/api/v1/spots/2111136.json")
    assert_equal(spot[0].city,"Barcelona")
    assert_equal(spot[0].point,2111136 )
    assert_not_nil(spot.to_s)

  end

  def test_get_swell
    swells = GotSurfService.new.get_swell 2111136
    assert_not_nil(swells.to_s)
  end

  def test_get_swell_error
    assert_raise StandardError do
      GotSurfService.new.get_swell 999999999
    end
  end
end