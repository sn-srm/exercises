#deletes all the elements in the given array that start with 's'

arr = ['snow', 'winter', 'ice', 'slippery', 'salted roads', 'white trees']

puts "before: #{arr}"

arr.delete_if {|values| values.start_with?("s")}

puts "after: #{arr}"


