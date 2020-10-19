def  verify_combination(hash)
if hash[:conjunction_c] && hash[:conjunction_m] then return false
elsif hash[:conjunction_c] == true
  return false  if (hash[:word_regex]== false && hash[:pattern_regex]== false && hash[:negative_regex] == false) || ((hash[:word_regex] && (hash[:pattern_regex] || hash[:negative_regex])) || ( hash[:pattern_regex] && hash[:negative_regex])) 
  elsif hash[:conjunction_m] == true
    return false if (hash[:word_regex]== false && hash[:pattern_regex]== false) ||   hash[:negative_regex] 
  elsif (hash[:word_regex] && (hash[:pattern_regex] || hash[:negative_regex])) or (hash[:pattern_regex] && hash[:negative_regex])
    return false
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
            exit 1
          elsif options[:conjunction_c]
            result = getResult(file, 'w', pattern)
            puts result.length 
            exit 1 
          elsif options[:conjunction_m]
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
              exit 1
            elsif options[:conjunction_c]
              result = getResult(file, 'p', pattern)
              puts result.length 
              exit 1 
            elsif options[:conjunction_m]
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
              exit 1
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
# print ARGV ," \n"
if ARGV.length < 2
    puts "Missing required arguments"
    return
end
# find the filename and remove it from the array
file_name = ARGV.find{|x| x.end_with?(".txt")}
if file_name == nil
    puts "Missing required arguments"
    return
else 
    ARGV.delete_at(ARGV.find_index(file_name))
end
#get options from command
options_arr = ARGV.select{|x| x.start_with?("-")}
if options_arr.uniq.length < options_arr.length # check for duplicate options
  puts "Invalid combination of options"
  exit 1
end
second_ref = options_arr.uniq
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
      exit
    end
  end
else
  #default option if no options are passed
  options[:pattern_regex] = true
end
# check if no options were passed, if so set pattern regex equals to true
# # check for the pattern
# print ARGV[0...(ARGV.length - 1)] , "\n"
non_options = ARGV[0...(ARGV.length - 1)].reject{|x| x.start_with?("-")} # ARGV[0...ARGV.lenth -1 ] is the options interval
if non_options.size >= 1 # check if the user passed in something other than an option and its trash
  puts "invalid option"
  exit 
end

if !ARGV.empty?
    pattern = ARGV[-1]
end
 
    if (second_ref.include?("-c") || second_ref.include?("-m")) && second_ref.size == 1
        options[:pattern_regex] = true
        executeCommands(file_name, options, pattern ) 
        exit 
      elsif verify_combination(options) == true #check all of the combinations
        executeCommands(file_name, options, pattern )   
        exit 
      else
        puts "Invalid combination of options"
          exit
      end





