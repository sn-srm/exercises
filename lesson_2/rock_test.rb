VALID_CHOICES = ['Rock','Paper','Scissors']

def prompt(message)
	puts ("==> #{message}")
end

VALID_CHOICES.each do |x|
	prompt(x)
end

