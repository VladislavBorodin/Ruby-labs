balance = 100
    if File.size("balance.txt")>0
    balance=File.read("balance.txt").to_i 
    end
begin
    puts"Please enter a symbol for choosing operation"
    puts "D for depozit"
    puts "W for withdraw"
    puts "B for balance"
    puts "Q for quit"
    $operatorF=gets.chomp.to_s  
    case $operatorF
        when "D"
            puts "Enter a summ for adding to balance:"
            depozit=gets.chomp.to_i
            if depozit>0  
            balance=balance+depozit  
            else puts "you have entered wrong count" 
            end
            puts "balance is now:" + balance.to_s
        when "W"
            puts "Enter a coun for adding from balance:"
            withdraw=gets.chomp.to_i
            if withdraw>0 and withdraw<balance  
            balance=balance-withdraw 
            else puts "balance cannot be below 0" 
            end
            puts "balance is now:" + balance.to_s
        when "B"
            puts "balance is now:" + balance.to_s
        when "Q"
            File.write("balance.txt", balance)
            break
        else
            puts "you have entered unknown symbol"
    end
    
end while $operatorF
