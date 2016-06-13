require 'pry'

PLAYER_PIECE = "X"
COMPUTER_PIECE = "O"

def prompt(message)
  puts "=>#{message}"
end

def display_board(state)
  puts "      |         |       "
  puts " #{state[1]}    |   #{state[2]}     |   #{state[3]}    "
  puts "      |         |       "
  puts "______+_________+_______"
  puts "      |         |       "
  puts " #{state[4]}    |   #{state[5]}     |   #{state[6]}    "
  puts "      |         |       "
  puts "______+_________+_______"
  puts "      |         |       "
  puts " #{state[7]}    |   #{state[8]}     |   #{state[9]}    "
  puts "      |         |       "
end

def init_board() # initialize board
  hash_state = {}
  (1..9).each {|number| hash_state[number]= " "}
  hash_state
end

def empty_squares(board)
  board.select{|k,v| v == " "}.keys 
end 

def valid_user_choice?(user_choice_box, board) #
  board.select{|k,v| v == " "}.keys.include?(user_choice_box)
end

def update_user_choice!(choice, board) # update board
  board[choice] = 'X'
end 

def update_computer_choice!(choice, board)
  board[choice] = "O"
end  

def winner_found?(board)
  !!detect_winner(board)
end 

def detect_winner(board)
  
  winning_pairs = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  
  winning_pairs.each do |line|
    if board[line[0]] == PLAYER_PIECE && board[line[1]] == PLAYER_PIECE && board[line[2]] == PLAYER_PIECE
      return "You"
    elsif board[line[0]] == COMPUTER_PIECE && board[line[1]] == COMPUTER_PIECE && board[line[2]] == COMPUTER_PIECE
      return "Computer!"
    end
  end   

end 

def full_board?(board)
  return empty_squares(board).empty?
end 

board = init_board()
display_board(board)

user_choice = ''

loop do
  
  loop do 
    
    prompt("Choose a empty square : #{empty_squares(board).split(' ')}")
    user_choice = gets.chomp.to_i

    if empty_squares(board).include?(user_choice)
        update_user_choice!(user_choice, board)
        break
    else  
        prompt("enter a valid choice")
    end 
  end  
  
  p board
  
  prompt "computer can choose: #{empty_squares(board)}"
  computer_choice = empty_squares(board).keys.sample
  
  update_computer_choice!(computer_choice, board)
  prompt "Computer chose: #{computer_choice}"
  
  display_board(board)   
  #break if  (winner_found?(board)) || full_board?(board)
  prompt winner_found?(board)
end 
