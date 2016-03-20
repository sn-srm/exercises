
#progamatically populating hashes

contact_data = [["joe@email.com", "123 Main st.", "555-123-4567"],
            ["sally@email.com", "404 Not Found Dr.", "123-234-3454"]]
contacts = {"Joe Smith" => {}, "Sally Johnson" => {}}

key = contacts.keys
key_length = key.length-1

contacts.each_with_index do |(key, hash), index|

	hash[:name] = contact_data[index][0]
	hash[:address] = contact_data[index][1]
	hash[:phone] = contact_data[index][2]
	
end

p contacts
