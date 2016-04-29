# rock_paper_scissors game

VALID_CHOICES = %w(rock paper scissors)
def prompt(message)
  Kernel.puts("=> #{message}")
end

def clear_screen
  system('clear')
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'scissors' && second == 'paper')
end

def display_result(player, computer)
  if win?(player, computer)
    prompt "You won!"
  elsif win?(computer, player)
    prompt "Computer won!"
  else
    prompt "It's a tie!"
  end
end

def valid_answer?(answer)
  answer.downcase == 'y' || answer.downcase == 'n'
end

loop do # main loop
  clear_screen
  choice = ''
  
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("Not a valid choice")
    end
  end
  computer_choice = VALID_CHOICES.sample
  prompt("You chose: #{choice}: Computer chose: #{computer_choice}")
  display_result(choice, computer_choice)
  
  answer = ''
  loop do
    prompt("Do you want to play again? Enter Y or N")
    answer = Kernel.gets().chomp()
    break if valid_answer?(answer)
  end
  break unless answer == 'y'
end
