#get- ln amt, apr, ln duration
 
def prompt(message)
  puts(">>>>#{message}")
end
 
 #validate amount
def valid_amount?(loan)
  return loan.to_f() > 0 && (loan.empty?() == false)
end     
 
def valid_apr?(apr)
  return  apr.to_f() > 0 && (apr.empty?() == false)
end
 
def valid_duration?(duration)
  return duration.to_i() > 0 && (duration.empty?() == false)
end  
   
 
prompt ("enter amount, must be positive")
amount = '' 
loop do
  # get ln - amt
  amount = Kernel.gets().chomp()
  if  valid_amount?(amount) == false
    prompt ("Please enter valid amount")
  else
    break
  end  
end
 
prompt("enter apr, for example type '5' for 5 %")
apr = ''
loop do
   #get apr
   #validate apr
   apr = Kernel.gets().chomp()
   if valid_apr?(apr) == false
    prompt ("Please enter valid apr")
   else
    break
   end
end
 
prompt ("enter duration in years")
duration = ''
loop do
   duration = Kernel.gets().chomp()
   if valid_duration?(duration) == false
    prompt("Please enter valid duration")
   else
    break
   end  
end
#calculate monthly rate
yearly_rate =  apr.to_f() / 100
monthly_rate = yearly_rate / 12
months = duration.to_i() * 12
amount = amount.to_f()
#loan duration in months
#calculate
#P = L[c(1 + c)n]/[(1 + c)n - 1]
# L dollars, n months, montly interest rate of c

prompt ("yearly_rate: #{yearly_rate}")
prompt ("monthly_rate: #{monthly_rate}")
prompt ("months: #{months}")
prompt ("amount: #{amount}")

montly_payment = amount * ((monthly_rate * (1 + monthly_rate) * * months) / (((1 + monthly_rate) * * months) - 1 ))
prompt ("montly_payment: #{montly_payment}")
prompt ("adios")


