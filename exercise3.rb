
#selects all odd elements from the given array into a new array


arr = [1,2,3,4,5,6,7,8,9,10]

new_arr = arr.select {|x| x%2 != 0}

p new_arr
