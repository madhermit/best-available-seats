#!/usr/bin/env ruby

require "json"

class BestAvailableSeat
  def initialize(file)
    @json = read_and_validate_json(file)
  end

  def read_and_validate_json(file)
    JSON.parse(File.read(file))
  rescue
    puts "Invalid JSON"
  end

  def find_best_seat
    venue = @json["venue"]
    seats = @json["seats"]

    num_rows = venue["layout"]["rows"] # letters
    num_cols = venue["layout"]["columns"] # numbers
    row_letters = ("a".."z").to_a
    row_priorities = get_row_priority(num_cols)

    num_rows.times do |row|
      row_priorities.each do |col|
        id = "#{row_letters[row]}#{col}"
        if seats[id] && seats[id]["status"] == "AVAILABLE"
          return {
            seat: id,
            msg: "Best available seat in the theatre is #{id}. Grab it quick!"
          }
        end
      end
    end
    {seat: nil, msg: "Theatre is sold out!"}
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
    (1..rows).each do |row|
      (1..cols).each do |col|
        rl = row_letters[row - 1]
        id = "#{rl}#{col}"
        status = seats_taken.include?(id) ? "UNAVAILABLE" : "AVAILABLE"
        seats[id] = {id: id, row: rl, column: col, status: status}
      end
    end
    {venue: {layout: {rows: rows, columns: cols}}, seats: seats}
  end
end

if ARGV.empty?
  puts "Invalid option: either type 'generate' to create a theatre, or supply a json file"
elsif ARGV[0] == "generate"
  theatre = BestAvailableSeat.make_theatre(10, 50, ["a2", "b2"])
  puts JSON.pretty_generate(theatre)
else
  rtn = BestAvailableSeat.new(ARGV[0]).find_best_seat
  puts rtn[:msg]
end
