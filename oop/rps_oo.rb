module Rules
  VALUES = %w(rock paper scissors lizard spock).freeze

  SHORTCUTS = { 'r' => 'rock',
                'p' => 'paper',
                's' => 'scissors',
                'l' => 'lizard',
                'c' => 'spock'
              }.freeze

  WINNING_RULES = { 'rock' => %w(scissors lizard),
                    'paper' => %w(rock spock),
                    'scissors' => %w(paper lizard),
                    'lizard' => %w(spock paper),
                    'spock' => %w(scissors rock)
                  }.freeze
end

# Functions used to display game state
module Display
  def display_round
    puts "round #{round}............"
  end

  def display_choices
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"
  end

  def display_score
    puts "#{human.name} : #{human.score} ... "
    puts "#{computer.name} : #{computer.score}..."
  end

  def clear_screen
    system('clear')
  end

  def pause_screen
    puts 'Press Enter to Continue'
    gets.chomp
  end
end

# Base class for all players
class Player
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
      hsh[move] = { win: 0, loss: 0, tie: 0 }
    end
    hsh
  end
end

# Class for the user player
class Human < Player
  def initialize
    super()
    @name = 'User'
  end

  def choose_move
    user_choice = ''
    loop do
      print 'Enter '
      SHORTCUTS.each do |k, v|
        print "(#{k}) for #{v}, "
      end
      user_choice = gets.chomp.downcase
      break if SHORTCUTS.keys.include?(user_choice)
    end
    puts '' # break the line
    @move = SHORTCUTS[user_choice]
  end
end

# Base class for all types of computer players
class Computer < Player
  @types = []
  class << self
    attr_reader :types

    def inherited(child_name)
      @types << child_name
    end
  end
end

# R2D2 only chooses one move for an entire game
class R2D2 < Computer
  def initialize
    super()
    @only_move = VALUES.sample
    @name = 'R2D2'
  end

  def choose_move
    @move = @only_move
  end
end

# Hal puts more weight on one random move for an entire game
class Hal < Computer
  def initialize
    super()
    @adjusted_moves = create_adjusted_moves
    @name = 'HAL'
  end

  def create_adjusted_moves
    choices = VALUES.map(&:dup)
    higher_weighted_move = choices.sample
    [1, 2, 3].each { choices << higher_weighted_move }
    choices
  end

  def choose_move
    @move = @adjusted_moves.sample
  end
end

# This chooses moves based on history
class BB8 < Computer
  def initialize
    super()
    @name = 'BB8'
  end

  def choose_move
    @move = weight_adjust_moves.sample
  end

  def calculate_move_weights
    total_losses = calculate_total_losses
    weights = {}
    VALUES.each do |move|
      if history[move][:loss] > 0 && history[move][:loss] / total_losses > 0.6
        weights[move] = 1
      else
        weights[move] = 2
      end
    end
    weights
  end

  def weight_adjust_moves
    weights = calculate_move_weights
    adjusted_moves = []

    weights.each do |move, weight|
      weight.times do
        adjusted_moves << move
      end
    end
    adjusted_moves
  end

  def calculate_total_losses
    total_losses = 0

    VALUES.each do |move|
      total_losses += history[move][:loss]
    end
    total_losses
  end
end

# General chooses a pure random move
class General < Computer
  def initialize
    super()
    @name = 'Apple'
  end

  def choose_move
    @move = VALUES.sample
  end
end

# Game runner class a
class Engine
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
      :human
    elsif win_round?(computer, human)
      :computer
    else
      :none
    end
  end

  def human_won
    update_winner(human)
    increase_score(human)
    update_winner_history(human, computer)
  end

  def computer_won
    update_winner(computer)
    increase_score(computer)
    update_winner_history(computer, human)
  end

  def game_tied
    @winner = 'none'
    computer.history[computer.move][:tie] += 1
    human.history[human.move][:tie] += 1
  end

  def round_over
    case find_round_winner
    when :human
      human_won
    when :computer
      computer_won
    when :none
      game_tied
    end
  end

  def update_winner(player)
    @winner = player.name
  end

  def increase_score(winner)
    winner.score += 1
  end

  def update_winner_history(winner, loser)
    winner.history[winner.move][:win] += 1
    loser.history[loser.move][:loss] += 1
  end

  def increase_round
    @round += 1
  end

  def find_choices
    display_round
    display_score
    human.choose_move
    computer.choose_move
    display_choices
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
      round_over
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
    response = gets.chomp.downcase
    break if %w(y n).include?(response)
  end
  play_again = false if response == 'n'
end
puts 'Bye!!!!'
