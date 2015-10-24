#!/usr/bin/ruby
fp = open("|pmset -g ps")
raw_data = fp.readlines[1]
fp.close

data = raw_data.gsub(/;/, '').split

if raw_data.match("discharging")
  if data[3].match(/\d{1,2}:\d{2}/).nil?
    puts "Battery: #{data[1]} [Calculating...] / "
  else
    puts "Battery: #{data[1]} [#{data[3]} remaining] / "
  end
elsif raw_data.match("charging")
  puts "Battery: #{data[1]} [Charging] / "
elsif raw_data.match("charged")
  puts "Battery: #{data[1]} [Charged] / "
end
