# tic tac toe

PLAYER_PIECE = 'X'.freeze
COMPUTER_PIECE = 'O'.freeze
EMPTY_PIECE = ' '.freeze
WINNING_PAIRS = [[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9],
                 [1, 4, 7],
                 [2, 5, 8],
                 [3, 6, 9],
                 [1, 5, 9],
                 [3, 5, 7]
                ].freeze

def prompt(message)
  puts "=> #{message}"
end

def display_board(board)
  puts '________________________'
  puts '      |         |       '
  puts " #{board[1]}    |   #{board[2]}     |   #{board[3]}    "
  puts '      |         |       '
  puts '______+_________+_______'
  puts '      |         |       '
  puts " #{board[4]}    |   #{board[5]}     |   #{board[6]}    "
  puts '      |         |       '
  puts '______+_________+_______'
  puts '      |         |       '
  puts " #{board[7]}    |   #{board[8]}     |   #{board[9]}    "
  puts '      |         |       '
  puts '________________________'
end

def joinor(arr, delimiter = ', ', word = 'or')
  arr[-1] = "#{word} #{arr.last}" if arr.length > 1
  arr.join(delimiter)
end

def init_board
  board = {}
  (1..9).each { |number| board[number] = EMPTY_PIECE }
  board
end

def empty_squares(board)
  board.select { |_k, v| v == EMPTY_PIECE }.keys
end

def get_user_choice(board)
  loop do
    prompt("Choose a square: #{joinor(empty_squares(board))}")
    user_choice = gets.chomp.to_i

    if empty_squares(board).include?(user_choice)
      board[user_choice] = PLAYER_PIECE
      break
    else
      prompt('enter a valid choice')
    end
  end
end

def get_computer_choice(board)
  prompt "Computer's turn............"
  sleep(1.0)
  computer_choice = if favorable_box?(board, COMPUTER_PIECE)
                      detect_favorable_box(board, COMPUTER_PIECE)
                    elsif favorable_box?(board, PLAYER_PIECE)
                      detect_favorable_box(board, PLAYER_PIECE)
                    elsif empty_squares(board).include?(5)
                      5
                    else
                      empty_squares(board).sample
                    end
  board[computer_choice] = COMPUTER_PIECE
end

def favorable_box?(board, marker)
  !!detect_favorable_box(board, marker)
end

def detect_favorable_box(board, marker)
  WINNING_PAIRS.each do |line|
    if board.values_at(*line).count(marker) == 2
      return board.select { |k, v| line.include?(k) && v == EMPTY_PIECE }.keys.first
    end
  end
  nil
end

def round_winner_found?(board)
  !!detect_round_winner(board)
end

def detect_round_winner(board)
  WINNING_PAIRS.each do |line|
    if board.values_at(*line).count(PLAYER_PIECE) == 3
      return "player"
    elsif board.values_at(*line).count(COMPUTER_PIECE) == 3
      return "computer"
    end
  end
  nil
end

def full_board?(board)
  empty_squares(board).empty?
end

def move_next(next_mover, board)
  if next_mover['mover'] == 0
    get_computer_choice(board)
    next_mover['mover'] = 1
  elsif next_mover['mover'] == 1
    get_user_choice(board)
    next_mover['mover'] = 0
  end
end

def choose_first_mover(next_mover)
  loop do
    prompt 'Enter the first mover'
    prompt '0 for Computer'
    prompt '1 for Player'
    first_mover = gets.chomp.to_i
    if first_mover == 0 || first_mover == 1
      next_mover["mover"] = first_mover
      break
    end
  end
end

def game_decided?(game_score)
  !!detect_game_winner(game_score)
end

def detect_game_winner(game_score)
  if game_score['player'] == 3
    'You won the game'
  elsif game_score['computer'] == 3
    'Computer won the game'
  elsif game_score['tie'] == 3 && game_score['player'] == 2
    'you won the game'
  elsif game_score['tie'] == 3 && game_score['computer'] == 2
    'computer won the game'
  elsif game_score['tie'] == 4 && game_score['player'] == 1
    'You won the game'
  elsif game_score['tie'] == 4 && game_score['computer'] == 1
    'computer won the game'
  end
end

def play_again?
  answer = ''
  loop do
    prompt 'Do you want to play another game? Enter (Y/N)'
    answer = gets.chomp
    break if answer.downcase == 'n' || answer.downcase == 'y'
  end
  answer.downcase == 'n'
end

loop do # main loop
  game_score_state = { 'round' => 0, 'player' => 0, 'computer' => 0, 'tie' => 0 }
  5.times do |round|
    board = init_board
    next_mover = { "mover" => 0 }
    prompt "Round #{round + 1} Player: #{game_score_state['player']} Computer: #{game_score_state['computer']}"
    display_board(board)
    choose_first_mover(next_mover)
    loop do
      move_next(next_mover, board)
      system('clear')
      prompt "Round #{round + 1} Player: #{game_score_state['player']} Computer: #{game_score_state['computer']}"
      display_board(board)
      break if round_winner_found?(board) || full_board?(board)
    end

    if detect_round_winner(board) == "player"
      game_score_state['player'] += 1
      prompt 'You won this round!'
    elsif detect_round_winner(board) == "computer"
      game_score_state['computer'] += 1
      prompt 'Computer won this round!'
    elsif full_board?(board)
      game_score_state['tie'] += 1
      prompt 'This round is a tie!'
    end
    if game_decided?(game_score_state)
      prompt detect_game_winner(game_score_state)
      break
    end
    game_score_state['round'] += 1
  end
  break if play_again?
end
