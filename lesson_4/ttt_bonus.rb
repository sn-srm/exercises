# tic tac toe

PLAYER_PIECE = 'X'.freeze
COMPUTER_PIECE = 'O'.freeze
EMPTY_PIECE = ' '.freeze
WINNING_PAIRS = [[1, 2, 3], [4, 5, 6], [7, 8, 9] +
  [1, 4, 7], [2, 5, 8], [3, 6, 9] +
    [1, 5, 9], [3, 5, 7]].freeze
PLAYER_WIN_SCORE = 1
COMPUTER_WIN_SCORE = -1

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

def init_board # initialize board
  board = {}
  (1..9).each { |number| board[number] = EMPTY_PIECE }
  board
end

def empty_squares(board)
  board.select { |k, v| v == EMPTY_PIECE }.keys
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
  if favorable_box?(board)
    computer_choice = detect_favorable_box(board)
    prompt("favorable_box")
  elsif risky_box?(board)
    computer_choice = detect_risky_box(board)
  elsif empty_squares(board).include?(5)
    computer_choice = 5
  else
    computer_choice = empty_squares(board).sample
  end
  board[computer_choice] = COMPUTER_PIECE
end

def risky_box?(board)
  !!detect_risky_box(board)
end

def detect_risky_box(board)
  WINNING_PAIRS.each do |line|
    if board[line[0]] == PLAYER_PIECE && board[line[1]] == PLAYER_PIECE &&
       board[line[2]] == EMPTY_PIECE
      return line[2]
    elsif board[line[0]] == PLAYER_PIECE && board[line[1]] == EMPTY_PIECE &&
          board[line[2]] == PLAYER_PIECE
      return line[1]
    elsif board[line[0]] == EMPTY_PIECE && board[line[1]] == PLAYER_PIECE &&
          board[line[2]] == PLAYER_PIECE
      return line[0]
    end
  end
  return
end

def favorable_box?(board)
  !!detect_favorable_box(board)
end

def detect_favorable_box(board)
  WINNING_PAIRS.each do |line|
    if board[line[0]] == COMPUTER_PIECE && board[line[1]] == COMPUTER_PIECE &&
       board[line[2]] == EMPTY_PIECE
      return line[2]
    elsif board[line[0]] == COMPUTER_PIECE && board[line[1]] == EMPTY_PIECE &&
          board[line[2]] == COMPUTER_PIECE
      return line[1]
    elsif board[line[0]] == EMPTY_PIECE && board[line[1]] == COMPUTER_PIECE &&
          board[line[2]] == COMPUTER_PIECE
      return line[0]
    end
  end
  return
end

def round_winner_found?(board)
  !!detect_round_winner(board)
end

def detect_round_winner(board)
  WINNING_PAIRS.each do |line|
    if board[line[0]] == PLAYER_PIECE && board[line[1]] == PLAYER_PIECE &&
       board[line[2]] == PLAYER_PIECE
      return PLAYER_WIN_SCORE
    elsif board[line[0]] == COMPUTER_PIECE && board[line[1]] == COMPUTER_PIECE &&
          board[line[2]] == COMPUTER_PIECE
      return COMPUTER_WIN_SCORE
    end
  end
  return
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

loop do # main loop
  game_score_state = { 'round' => 0, 'player' => 0, 'computer' => 0, 'tie' => 0}
  5.times do |round|
    board = init_board
    next_mover = { "mover" => 0 }
    prompt "Round #{round + 1}"
    display_board(board)
    choose_first_mover(next_mover)
    loop do
      move_next(next_mover, board)
      system('clear')
      prompt "Round #{round + 1}"
      display_board(board)
      break if round_winner_found?(board) || full_board?(board)
    end

    if detect_round_winner(board) == PLAYER_WIN_SCORE
      game_score_state['player'] += 1
      prompt 'You won this round!'
    elsif detect_round_winner(board) == COMPUTER_WIN_SCORE
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
    p game_score_state
  end

  answer = ''
  loop do
    prompt 'Do you want to play another game? Enter (Y/N)'
    answer = gets.chomp
    break if answer.downcase == 'n' || answer == 'y'
  end
  break if answer.downcase == 'n'
end
