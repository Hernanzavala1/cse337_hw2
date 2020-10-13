def  verify_combination(hash)
    if hash[:conjunction_c] == true
      return false  if hash[:word_regex]== false && hash[:pattern_regex]== false && hash[:negative_regex] == false 
  elsif hash[:conjunction_m] == true
       return false if hash[:word_regex]== false && hash[:pattern_regex]== false    
  end
    return true
end
def printResult(result)
  result.each{|line| puts line }
  exit 1
end
def getResult(file, flag, pattern )
  if flag == 'p'
    return file.readlines.select{ |line| line.match pattern } 
  elsif flag == 'w'
  return  file.readlines.select{ |line|  line.match /\b#{Regexp.escape(pattern)}\b/  } 
  elsif flag == 'v'
    return file.readlines.reject{|line| line.match pattern }
  end
end

def executeCommands(file_name, options, pattern)
  if File.exist?(file_name)
  file = File.open(file_name, "r")
  else 
    puts "File does not exist"
    return
  end
  options.each {
    |key, value|
    if value == true
      case key
      when :word_regex
          if !options[:conjunction_c] && !options[:conjunction_m]
            result = getResult(file, 'w', pattern)
            printResult(result)
          elsif options[:conjunction_c]
            result = getResult(file, 'w', pattern)
            puts result.length 
            exit 1 
          else 
            file.readlines.each{
               |line|
                x =  line.match /\b#{Regexp.escape(pattern)}\b/
                if x.class != NilClass
                   puts x[0]
                end
              }
              exit 1
          end
      when :pattern_regex
            if !options[:conjunction_c] && !options[:conjunction_m]
              result = getResult(file, 'p', pattern)
              printResult(result)
            elsif options[:conjunction_c]
              result = getResult(file, 'p', pattern)
              puts result.length 
              exit 1 
            else 
               file.readlines.each{
                  |line|
                   x = line.match(pattern)
                   if x.class != NilClass
                      puts x[0]
                   end
              }
              exit 1
            end
      when :negative_regex
            result =  getResult(file, 'v', pattern)
            if !options[:conjunction_c] 
              printResult(result)
            elsif options[:conjunction_c]
              puts result.length 
              exit 1 
            end  
    end
  end
  }
  file.close
end
#check if enough parameters have been passed
if ARGV.length < 2
    puts "Missing required arguments"
    return
end
# print ARGV.to_a, " before being stripped"
# ARGV.each{|e| e.strip}
# print ARGV.to_a, " after being stripped"
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





