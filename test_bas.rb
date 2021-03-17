require "minitest/autorun"
require_relative "bas"

class TestBestAvailableSeat < Minitest::Test
  def setup
    @bas = BestAvailableSeat.new
  end

  def test_make_theatre
    json = '{"venue":{"layout":{"rows":3,"columns":3}},"seats":{"a1":{"id":"a1","row":"a","column":1,"status":"AVAILABLE"},"a2":{"id":"a2","row":"a","column":2,"status":"AVAILABLE"},"a3":{"id":"a3","row":"a","column":3,"status":"AVAILABLE"},"b1":{"id":"b1","row":"b","column":1,"status":"AVAILABLE"},"b2":{"id":"b2","row":"b","column":2,"status":"AVAILABLE"},"b3":{"id":"b3","row":"b","column":3,"status":"AVAILABLE"},"c1":{"id":"c1","row":"c","column":1,"status":"AVAILABLE"},"c2":{"id":"c2","row":"c","column":2,"status":"AVAILABLE"},"c3":{"id":"c3","row":"c","column":3,"status":"AVAILABLE"}}}'

    theatre = BestAvailableSeat.make_theatre(3, 3)
    assert_equal json, theatre.to_json
  end

  def test_make_theatre_with_seats_taken
    json = '{"venue":{"layout":{"rows":3,"columns":3}},"seats":{"a1":{"id":"a1","row":"a","column":1,"status":"AVAILABLE"},"a2":{"id":"a2","row":"a","column":2,"status":"UNAVAILABLE"},"a3":{"id":"a3","row":"a","column":3,"status":"AVAILABLE"},"b1":{"id":"b1","row":"b","column":1,"status":"AVAILABLE"},"b2":{"id":"b2","row":"b","column":2,"status":"UNAVAILABLE"},"b3":{"id":"b3","row":"b","column":3,"status":"AVAILABLE"},"c1":{"id":"c1","row":"c","column":1,"status":"AVAILABLE"},"c2":{"id":"c2","row":"c","column":2,"status":"AVAILABLE"},"c3":{"id":"c3","row":"c","column":3,"status":"AVAILABLE"}}}'

    theatre = BestAvailableSeat.make_theatre(3, 3, ["a2", "b2"])
    assert_equal json, theatre.to_json
  end

  def test_get_row_priority_even_num_cols
    list = [6, 7, 5, 8, 4, 9, 3, 10, 2, 11, 1, 12]
    assert_equal list, @bas.get_row_priority(12)

    list = [5, 6, 4, 7, 3, 8, 2, 9, 1, 10]
    assert_equal list, @bas.get_row_priority(10)

    list = [4, 5, 3, 6, 2, 7, 1, 8]
    assert_equal list, @bas.get_row_priority(8)
  end

  def test_get_row_priority_even_odd_cols
    list = [5, 6, 4, 7, 3, 8, 2, 9, 1]
    assert_equal list, @bas.get_row_priority(9)

    list = [4, 5, 3, 6, 2, 7, 1]
    assert_equal list, @bas.get_row_priority(7)

    list = [3, 4, 2, 5, 1]
    assert_equal list, @bas.get_row_priority(5)
  end

  def test_find_best_seats
    theatre = BestAvailableSeat.make_theatre(3, 3, ["a1", "a2", "a3"])
    assert_equal("b2", @bas.find_best_seat(theatre.to_json))

    theatre = BestAvailableSeat.make_theatre(3, 3, ["a1", "a3", "b2"])
    assert_equal("a2", @bas.find_best_seat(theatre.to_json))

    theatre = BestAvailableSeat.make_theatre(3, 3, ["a1", "a2", "b2"])
    assert_equal("a3", @bas.find_best_seat(theatre.to_json))
  end
end
