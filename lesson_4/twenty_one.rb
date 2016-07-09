# Twenty One
SUITS = ["\u2665", "\u2663","\u2660", "\u2666"]
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze

def prompt(msg)
  puts "=> #{msg}"
end

def pause
  prompt "press enter to continue...."
  gets.chomp
end

def show_cards(cards)
  temp_arr = []
  cards.each do|card|
    temp_arr << card[0].encode('utf-8') + card[1]
  end
  temp_arr.join(', ')
end

def show_game_state(game_state)
  puts "Round : #{game_state['round']} Player : #{game_state['player_score']} Dealer: #{game_state['dealer_score']} "
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > 21
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(player_cards, dealer_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def update_score(result, game_state)
  case result
  when :player_busted
    game_state['dealer_score'] += 1
  when :dealer_busted
    game_state['player_score'] += 1
  when :player
    game_state['player_score'] += 1
  when :dealer
    game_state['dealer_score'] += 1
  when :tie
    game_state['tie'] += 1
  end
end

def display_result(player_cards, dealer_cards)
  result = detect_result(player_cards, dealer_cards)

  case result
  when :player_busted
    prompt "You busted! Dealer wins this round!"
  when :dealer_busted
    prompt "Dealer busted! You win this round!"
  when :player
    prompt "You win this round!"
  when :dealer
    prompt "Dealer wins this round!"
  when :tie
    prompt "This round is a tie!"
  end
end

def make_initial_deal!(deck, player_cards, dealer_cards)
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end
end

def show_initial_cards(player_cards, dealer_cards)
  prompt "Dealer has: #{dealer_cards[0][0]}#{dealer_cards[0][1]} and ?"
  prompt "You have: #{player_cards[0][0]}#{player_cards[0][1]} and #{player_cards[1][0]}#{player_cards[1][1]} for a total of #{total(player_cards)}."
end

def player_turn!(deck, player_cards)
  loop do
    player_turn = hit_or_stay
    if player_turn == 'h'
      player_cards << deck.pop
      prompt "You chose to hit!"
      prompt "Your cards are now: #{show_cards(player_cards)}"
      prompt "Your total is now: #{total(player_cards)}"
    end
    break if player_turn == 's' || busted?(player_cards)
  end
end

def hit_or_stay
  player_turn = nil
  loop do
    prompt "Would you like to (h)it or (s)tay?"
    player_turn = gets.chomp.downcase
    break if ['h', 's'].include?(player_turn)
    prompt "Sorry, must enter 'h' or 's'."
  end
  player_turn.downcase
end

def dealer_turn!(deck, dealer_cards)
  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= 17

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    prompt "Dealer's cards are now: #{show_cards(dealer_cards)}"
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def show_all_cards(player_cards, dealer_cards)
  puts "=============="
  prompt "Dealer has #{show_cards(dealer_cards)}, for a total of: #{total(dealer_cards)}"
  prompt "Player has #{show_cards(player_cards)}, for a total of: #{total(player_cards)}"
  puts "=============="
end

def winner_found?(game_state)
  game_state['player_score'] >= 5 || game_state['dealer_score'] >= 5
end

def declare_game_winner(game_state)
  if game_state['player_score'] > 3
    prompt "You win the game"
  else
    prompt "Dealer wins the game"
  end
end

loop do # main loop
  prompt "Welcome to Twenty-One!"
  game_state = { 'round' => 0, 'player_score' => 0, 'dealer_score' => 0, 'tie' => 0 }
  loop do
    system('clear')
    game_state['round'] += 1
    show_game_state(game_state)
    # initialize vars
    deck = initialize_deck
    player_cards = []
    dealer_cards = []
    # initial deal
    make_initial_deal!(deck, player_cards, dealer_cards)

    show_initial_cards(player_cards, dealer_cards)

    # player turn
    player_turn!(deck, player_cards)

    if busted?(player_cards)
      show_all_cards(player_cards, dealer_cards)
      display_result(player_cards, dealer_cards)
      game_state['dealer_score'] += 1
      pause
      winner_found?(game_state) ? break : next
    else
      prompt "You stayed at #{total(player_cards)}"
    end

    # dealer turn
    prompt "Dealer turn..."
    dealer_turn!(deck, dealer_cards)

    dealer_total = total(dealer_cards)
    if busted?(dealer_cards)
      # prompt "Dealer total is now: #{dealer_total}"
      show_all_cards(player_cards, dealer_cards)
      display_result(player_cards, dealer_cards)
      pause
      game_state['player_score'] += 1
      winner_found?(game_state) ? break : next
    else
      prompt "Dealer stays at #{dealer_total}"
    end

    # both player and dealer stays - compare cards!
    show_all_cards(player_cards, dealer_cards)
    result = detect_result(player_cards, dealer_cards)
    display_result(player_cards, dealer_cards)
    update_score(result, game_state)
    pause
    break if winner_found?(game_state)
  end
  # find game winner
  show_game_state(game_state)
  declare_game_winner(game_state)
  break unless play_again?
end

prompt "Thank you for playing Twenty-One! Good bye!"
