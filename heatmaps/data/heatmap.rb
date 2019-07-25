require 'csv'

name = ARGV.shift

csv = CSV.open("#{ name }_raw.csv")
lines = csv.read.map { |ary| [ary.first.split(' '), ary.last].flatten }
csv.close

CSV.open("#{ name }.csv", mode = 'wb') do |csv|
  # header row
  header = lines[0]
  header[0] = ['x', 'y', 'z']
  header.flatten!

  lines.each do |l|
    csv << l
  end
end
