# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

loop do #main loop
	
	def prompt(message)
			Kernel.puts("=>#{message}")
	end	
		

	def valid_number?(number)
		if number.to_i != 0 
			return true
		else
			return false
		end
	end

	def integer?(number)
		 /^\d+$/.match(number)
  end	
 
 	def operation_to_message(op)
		case op
		when '1'
			'Adding'
		when '2'
			'Subtracting'
		when '3'
			'Multiplying'
		when '4'
			'Dividing'
		end		
		
	end
	
	Kernel.puts("Welcome to Calculator!")
	name = ''
	
	loop do
		prompt ("Enter your name:")
		name = Kernel.gets().chomp
		if name.empty?
			prompt ("Make sure you're using a valid name")
		else
			break
		end

	end

	number1 = ''
	loop do
		prompt("What's the first number?")
		number1 = Kernel.gets().chomp()

		if integer?(number1)
			break
		else
			prompt("Hmm.. that doesn't look like a valid number")
		end	
	end	

	number2 = ''
	loop do
		prompt("whats the second number?")
		number2 = Kernel.gets().chomp()

		if integer?(number2)
			break
		else
			prompt("Hmm.. that doesn't look like a valid number")
		end 
			
	end
	
	operator_prompt = <<-MSG
		What operation would you like to perform?
		1) add
		2) subtract
		3) multiply
		4) divide	
	MSG

	operator = ''
	loop do
		
		prompt(operator_prompt)
		operator = Kernel.gets().chomp()

		if %w(1 2 3 4).include?(operator)
			break
		else
			prompt ("Must choose 1 2 3 or 4")
		end
	end	

	prompt ("#{operation_to_message(operator)} the two numbers....")

	result = case operator
		when '1'
		 	number1.to_i() + number2.to_i()
		 when '2'
		 	number1.to_i() - number2.to_i()
		 when '3'
		 	number1.to_i() * number2.to_i()
		 when '4'
		 	number1.to_f() / number2.to_f()
	end	

	prompt ("The result is #{result}")
	prompt ("Do you want to do another calculation?")

	answer = Kernel.gets().chomp()
	break unless answer.downcase().start_with?('y')

end