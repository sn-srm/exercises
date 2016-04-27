VALID_CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
	Kernel.puts("=> #{message}")
end

def clear_screen()
	system('clear')
end

def display_result(player, computer)
	if (player=='rock' && computer == 'scissors') ||
			(player=='paper' && computer == 'rock') ||
			(player=='scissors' && computer == 'paper') 
		prompt ("You won!")
	elsif (player=='rock' && computer == 'paper') ||
				(player=='paper' && computer == 'scissors') ||
				(player=='scissors' && computer == 'rock')
		prompt ("Computer won!")
	else
		prompt("It's a tie!")
	end		
end
def valid_answer?(answer)
	answer.downcase == 'y' || answer.downcase == 'n'
end	



loop do
	clear_screen
	choice = ''
	loop do
		prompt ("Choose one: #{VALID_CHOICES.join(', ')}")
		choice = Kernel.gets().chomp()
		if VALID_CHOICES.include?(choice)
			break
		else
			prompt ("Not a valid choice")
		end
	end
	computer_choice = VALID_CHOICES.sample

	Kernel.puts ("You chose: #{choice}: Computer chose: #{computer_choice}")
	display_result(choice, computer_choice)
	answer = ''
	loop do
		prompt("Do you want to play again? Enter Y or N")
		answer = Kernel.gets().chomp()
		if valid_answer?(answer) 
			break
		end
	end
	break unless answer == 'y' 
end
