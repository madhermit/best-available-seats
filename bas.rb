#!/usr/bin/env ruby

require "json"

class BestAvailableSeat
  # json = '{"venue": {"layout": {"rows": 10,"columns": 50}},"seats": {"a1": {"id": "a1","row": "a","column": 1,"status": "AVAILABLE"},"b5": {"id": "b5","row": "b","column": 5,"status": "AVAILABLE"},"h7": {"id": "h7","row": "h","column": 7,"status": "AVAILABLE"}}}'
  #
  # Seating solution options:
  # 1.) Not too far from the center, avoiding side seats, effectively a semicircle around the front middle seat.
  # - first pass: any seat within an increasing number of seats from the prime seat, up to a third of the row (creating a half circle).
  # - second pass: prefering the center and moving back filling rows as needed.
  # **2.) Sides aren't bad!
  # Based on "For 5 columns and 2 requested seats the best open seats - assuming the first row A is fully occupied and the second row B is fully open, would be B2 and B3." we can infer that these people will prefer row A to row B, so no need to overcomplicate things.

  def initialize(json)
    @theatre = JSON.parse(json)
  end

  def find_best_seat
    venue = @theatre["venue"]
    seats = @theatre["seats"]

    num_rows = venue["layout"]["rows"] # letters
    num_cols = venue["layout"]["columns"] # numbers
    row_letters = ("a".."z").to_a
    row_priorities = get_row_priority(num_cols)

    num_rows.times { |row|
      row_priorities.each { |col|
        id = "#{row_letters[row]}#{col}"
        return id if seats[id] && seats[id]["status"] == "AVAILABLE"
      }
    }
    nil
  end

  # Find the middle seat of a row by:
  # - starting in the middle
  # - add seat to right (add distance from center seat)
  # - add seat to left (subtract distance from center seat)
  # - repeat until you reach the end of the row
  # TODO refactor
  def get_row_priority(num_cols)
    c = (num_cols.to_f / 2).ceil
    rtn = [c]
    (1..num_cols / 2).each do |x|
      rtn << c + x
      rtn << c - x
    end
    rtn.pop if num_cols.even?
    rtn
  end

  def self.make_theatre(rows, cols, seats_taken = [])
    row_letters = ("a".."z").to_a
    seats = {}
    (1..rows).each { |row|
      (1..cols).each { |col|
        rl = row_letters[row - 1]
        id = "#{rl}#{col}"
        status = seats_taken.include?(id) ? "UNAVAILABLE" : "AVAILABLE"
        seats[id] = {id: id, row: rl, column: col, status: status}
      }
    }
    {venue: {layout: {rows: rows, columns: cols}}, seats: seats}
  end
end

theatre = BestAvailableSeat.make_theatre(10, 50, ["a2", "b2"])
best_seat = BestAvailableSeat.new(theatre.to_json).find_best_seat
puts "Best available seat in the theatre is: #{best_seat}. Grab it quick!"
