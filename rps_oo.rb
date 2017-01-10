require 'pry'

module Rules
  VALUES = %w[rock paper scissors lizard spock].freeze
  SHORTCUTS = {'r' => 'rock', 'p' => 'paper', 's' => 'scissors', 'l' => 'lizard', 'c' => 'spock'}
  WINNING_RULES = {'rock' => %w(scissors),  
                   'paper' => %w(rock spock), 
                   'scissors' => %w(paper lizard),
                   'lizard' => %w(spock paper), 
                   'spock' => %w(scissors rock)
    
  }
  
end

module Display
  def display_round
    puts "round #{round}............"
  end
  
  def display_score
    puts "#{human.name} : #{human.score} ... #{computer.name} : #{computer.score}"
  end

  def clear_screen
    system('clear')
  end

  def pause_screen
    puts "Press Enter to Continue"
    gets.chomp
  end 
end

class Player  #player class
  include Rules
  attr_accessor :move, :name, :score, :history
  def initialize
    @name = name
    @history = create_history
    @score = 0
  end

  def create_history
    hsh = {}
    VALUES.each do |move|
      # hsh[move] = { :win => 0, :loss =>0, :tie =>0 }
      hsh[move] = { win: 0, loss: 0, tie: 0 }
    end
    hsh
  end
end

class Human < Player #Class Human
  
  def detect_move
    user_choice = ''
    
    loop do
      # puts "Enter one of these: #{VALUES.join(', ')}"
      print "Enter " 
      SHORTCUTS.each do |k,v|
        print "(#{k}) for #{v}, "
      end
      
      user_choice = gets.chomp
      break if SHORTCUTS.keys.include?(user_choice)
    end
    
    puts ""  #break the line
    @move = SHORTCUTS[user_choice]
  end
    
    def name
      "User"
    end
  
end

class Computer < Player
  @types = []
  class << self
    attr_reader :types
    
    def inherited(child_name)
      @types << child_name
    end
  end
end 

class R2D2 < Computer # R2D2 only chooses one move per game
  @only_move
  def initialize
    super()
    @only_move = VALUES.sample
  end
  
  def detect_move
    choice = @only_move
    @move = choice
  end

  def name
    'R2D2'
  end
end


class Hal < Computer # Hal has a tendency to choose one random move more than others
  @adjusted_moves
  
  def initialize
    super()
    choices = VALUES.map(&:dup)
    higher_weighted_move = choices.sample
    [1, 2, 3].each { choices << higher_weighted_move }
    @adjusted_moves = choices
  end

  def detect_move
    @move = @adjusted_moves.sample
  end

  def name
    "HAL"
  end
end

class General < Computer
  def detect_move
    choice = get_weight_adjusted_moves.sample
    @move = choice
  end

  def name
    'Apple'
  end
    
  def get_move_weights()
    total_losses = get_total_losses
    weights = {}
    VALUES.each do |move|
      if histroy[move][:loss] > 0 && history[move][:loss] / total_losses > 0.6
        weights[move] = 1
      else
        weights[move] = 2
      end 
    end
    weights
  end

  def get_weight_adjusted_moves
    weights = get_move_weights
    adjusted_moves = []
    
    weights.each do |move,weight|
      weight.times do 
        adjusted_moves << move
      end
    end
    adjusted_moves
  end

  def get_total_losses
    total_losses = 0
    
    VALUES.each do |move|
      total_losses += history[move][:loss]
    end
    total_losses
  end
end

class Engine  # Game runner
  include Rules
  include Display
  attr_accessor :human, :computer, :round, :winner, :history
  
  def initialize
    @human = Human.new
    @computer = Computer.types.sample.new
    @round = 0
  end
  
  def win_round?(player1, player2)
    WINNING_RULES[player1.move].include?(player2.move)
  end
  
  def winner_found?
    computer.score == 5 || human.score == 5
  end

  def find_round_winner
    if win_round?(human, computer)
      update_winner_history(human, computer)
    elsif win_round?(computer, human)
      update_winner_history(computer, human)
    else
      update_tie
    end
  end

  def update_winner_history(winner, loser)
    @winner = winner.name
    winner.score += 1
    winner.history[winner.move][:win] += 1
    loser.history[loser.move][:loss] += 1
  end
  
  def update_tie
    @winner = 'none'
    computer.history[computer.move][:tie] += 1
    human.history[human.move][:tie] += 1
  end

  def increase_round
    @round += 1
  end
  
  def find_choices
    display_round
    display_score
    human.detect_move
    computer.detect_move
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"
  end 

  def display_results
    display_score
    pause_screen
    clear_screen
  end 
  
  def play
    until winner_found?
      increase_round
      find_choices
      find_round_winner
      puts "#{winner} won this round!"
      display_results
    end
    display_score
    puts "#{winner} won the game!"
  end
end

play_again = true
while play_again == true
  game = Engine.new
  game.play
  response = ''
  loop do
    puts "Do you want to play again? Press 'y' for yes and 'n' for no..."
    response = gets.chomp
    break if %w(y n).include?(response.downcase)
  end
  play_again = false if response == 'n'
end
