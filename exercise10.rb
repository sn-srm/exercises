# array as hash values

candidates = {democrats: ['Bernie', 'Clinton'], republicans:['Trump', 'Kashich']}

puts candidates[:democrats]


array = [{color: 'red', shape:'round' },{color: 'green', shape: 'square' }]


array.each do |x|
	
	puts x[:color]
	puts x[:shape]

end