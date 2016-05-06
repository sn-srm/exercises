# Rock Paper Scissors Lizard Spock

WINNING_RULES = { 'rock' => %w(lizard scissors), # this should be read as - rock wins lizard and scissors
                  'paper' => %w(spock rock),
                  'scissors' => %w(lizard paper),
                  'spock' => %w(rock scissors),
                  'lizard' => %w(spock paper)
      }.freeze

SHORTCUT_RULES = { "r" => "rock", "p" => "paper", "s" => "scissors", "o" => "spock", "l" => "lizard" }.freeze

def prompt(message)
  puts "=> #{message}"
end

def clear_screen
  system('clear')
end

def win?(first, second, rules)
  rules[first].include?(second)
end

def display_results(user_wins, computer_wins)
  if user_wins > computer_wins
    prompt("You won the game!")
  elsif computer_wins > user_wins
    prompt("Computer won the game!")
  else
    prompt("It's a tie!")
  end
end
       
def valid_answer?(answer)
  answer.downcase == 'y' || answer.downcase == 'n'
end

loop do # main loop
  user_choice_key = ""
  user_wins = 0
  computer_wins = 0
  winner_found = false
  round = 1 # keeping track of rounds
  until winner_found == true 
    clear_screen()
    prompt("--------------------Round #{round}----------------------")
    loop do
      prompt("Enter your choice")
      prompt("R for rock, P for paper, S for scissors, L for lizard, O for spock")
      user_choice_key = Kernel.gets().chomp()
      break if SHORTCUT_RULES.key?(user_choice_key.downcase)
    end

    user_choice = SHORTCUT_RULES[user_choice_key]
    computer_choice = WINNING_RULES.keys.sample

    prompt "your choice: #{user_choice}"
    prompt "Computer choice : #{computer_choice}"

    if win?(user_choice, computer_choice, WINNING_RULES)
      prompt("You won this round!")
      user_wins += 1
    elsif win?(computer_choice, user_choice, WINNING_RULES)
      prompt("Computer won this round!")
      computer_wins += 1
    else
      prompt("It's a tie!")
    end
    
    prompt "Current Score -----------user: #{user_wins}-------------Computer: #{computer_wins}" # display current score
    prompt("Press enter to continue...")
    Kernel.gets # pause the screen
    
    round += 1
    winner_found = true if user_wins == 5 || computer_wins == 5
  end
  
  display_results(user_wins, computer_wins)
  answer = ''
  loop do
    prompt("Do you want to play again? Enter Y or N")
    answer = Kernel.gets().chomp()
    break if valid_answer?(answer)
  end      
  
  break unless answer.downcase == 'y'
end
prompt "Bye!"
