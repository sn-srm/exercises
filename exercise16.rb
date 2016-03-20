#splits each item and creates a new array of all splitted elements

a = ['white snow', 'winter wonderland', 'melting ice',
     'slippery sidewalk', 'salted roads', 'white trees']

a = (a.map { |a| a.split }).flatten

p a

