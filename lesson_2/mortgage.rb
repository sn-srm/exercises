# Mortgage Calculator
# Formula to be used - P = L[c(1 + c)n]/[(1 + c)n - 1]
# L dollars, n months, montly interest rate of c

def prompt(message)
  puts("-->>>#{message}")
end

# validate amount
def invalid_amount?(loan)
  loan.to_f <= 0 || loan.empty?
end

# validate apr
def invalid_apr?(apr)
  apr.to_f <= 0 || apr.empty?
end

# validate loan duration
def invalid_duration?(duration)
  duration.to_i <= 0 || duration.empty?
end

# validate answer to do calculation (y/n)
def invalid_answer?(answer)
  answer.downcase != 'y' && answer.downcase != 'n'
end

# clear screen
def clear_screen
  system 'clear'
end

loop do # main loop
  amount = ''
  loop do
    prompt 'enter valid amount, must be positive'
    amount = Kernel.gets.chomp
    break unless invalid_amount?(amount)
  end
  
  apr = ''
  loop do
    prompt("enter valid apr, for example type '5' for 5 %")
    apr = Kernel.gets.chomp
    break unless invalid_apr?(apr)
  end

  duration = ''
  loop do
    prompt("enter valid duration in years")
    duration = Kernel.gets.chomp
    break unless invalid_duration?(duration)
  end
  yearly_rate =  apr.to_f / 100
  monthly_rate = yearly_rate / 12
  months = duration.to_i * 12
  amount = amount.to_f
  clear_screen()
  prompt "yearly_rate: #{yearly_rate}"
  prompt "monthly_rate: #{monthly_rate}"
  prompt "months: #{months}"
  prompt "amount: #{amount}"

  montly_payment = amount * ((monthly_rate * (1 + monthly_rate)**months) / (((1 + monthly_rate)**months) - 1))
  prompt "montly_payment: #{'%.02f' % montly_payment}"
  answer = ''
  loop do
    prompt 'Do you want to do another calculation? Enter Y or N'
    answer = Kernel.gets.chomp
    break unless invalid_answer?(answer)
  end
  break unless answer.downcase == 'y'
end # end main loop