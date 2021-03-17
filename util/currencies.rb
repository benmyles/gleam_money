#!/usr/bin/env ruby

# Simple script to parse currencies.txt and output a list of tuples.
# Source data from https://github.com/elixirmoney/money/blob/v1.8.0/lib/money/currency.ex.

File.read(File.join(File.dirname(__FILE__), "currencies.txt")).split("\n").each do |line|
  code = line.match(/(\w{3}):/)[1]
  name = line.match(/name:\s"([^"]+)"/)[1]
  symbol = line.match(/symbol:\s"([^"]+)"/)[1]
  exponent = line.match(/exponent:\s(\d+)/)[1].to_i
  number = line.match(/number:\s(\d+)/)[1].to_i

  puts <<-EOF
  tuple(
    "#{code}",
    Currency(
      code: "#{code}",
      symbol: "#{symbol}",
      numeric_code: #{number},
      minor_units: #{exponent},
      name: "#{name}",
    ),
  ),
  EOF
end