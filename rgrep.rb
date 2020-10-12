def  verify_combination(hash)
    if hash[:conjunction_c] == true
        if hash[:word_regex]== false && hash[:pattern_regex]== false && hash[:negative_regex] == false
            return false
        else 
            return true
        end
    end
    if hash[:conjunction_m] == true
        if hash[:word_regex]== false && hash[:pattern_regex]== false 
            return false
        else 
            return true
        end
    end
    return false
end
def executeCommands(file_name, options, pattern)
  if File.exist?(file_name)
  file = File.open(file_name, "r")
  else 
    puts "File does not exist"
    return
  end
  

end

#check if enough parameters have been passed
if ARGV.length < 2
    puts "Missing required arguments"
    return
end
# find the filename and remove it from the array
file_name = ARGV.find{|x| x.end_with?(".txt")}
if file_name == nil
    puts "No file provided"
    return
else 
    ARGV.delete_at(ARGV.find_index(file_name))
end
#get options from command
options_arr = ARGV.select{|x| x.start_with?("-")}
options = {:word_regex => false, :pattern_regex => false, :negative_regex => false, :conjunction_c=> false, :conjunction_m=> false}
if !options_arr.empty?
  while !options_arr.empty? 
    option = options_arr.shift
    case option
    when "-w"
      options[:word_regex] = true
    when "-p"
      options[:pattern_regex] = true
    when "-v"
      options[:negative_regex] = true
    when "-c"
      options[:conjunction_c] = true
    when "-m"
      options[:conjunction_m] = true
    else
      puts "Invalid option"
      return
    end
  end
else
  #default option if no options are passed
  options[:pattern_regex] = true
end
# check if no options were passed, if so set pattern regex equals to true
# # check for the pattern
if !ARGV.empty?
    # pattern = ARGV.reject!{|x| x.start_with?("-")}
    pattern = ARGV[-1]
end
# check for valid combination
if options[:conjunction_c]== true || options[:conjunction_m] == true
    if verify_combination(options) == false
        puts "Invalid combination of options"
        return
    end
end
executeCommands(file_name, options, pattern )





