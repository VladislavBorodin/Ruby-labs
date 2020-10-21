students = []
File.write("result.txt", "data:")
    age=0
   begin
        puts "Please enter age or -1 for exit:"
        age=gets.chomp
        File.write("result.txt", "\n Age="+age, mode:"a") 
            File.foreach("stud.rb") do |line| 
                students.push(line.chomp.split(" "))
                if line.chomp.split(" ").include?(age)
                File.write("result.txt", "\n"+line.chomp, mode: "a") 
                puts "some persons find"
                end
            end
    end while age.to_i>=0
#puts students
Result12 = File.read("result.txt").split("\n") 
puts Result12