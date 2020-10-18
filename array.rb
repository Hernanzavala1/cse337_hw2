
class Array
    alias old [] 
    def [](i)
        x = self.size
        if x ==0
            return '\0'
        end
        # get the interval for correct indices
        lowerBound = x * -1
       upperBound = x - 1
       if i < lowerBound || i > upperBound
        return '\0'
       end
       return old(i)
    end
    alias oldMap map 
    def map (sequence = nil, &block)
        result = []
        temp = []
        if sequence == nil
            # call the old map 
            return self.oldMap(&block) 
        else 
            if sequence.class == Range && block_given? && sequence.all? { |x| x.is_a? Integer }
                beginning  = self.size * -1
                end_index = self.size - 1 
                valid_indices = Range.new(beginning, end_index)
                if (sequence.to_a & valid_indices.to_a).empty? == false
                    sequence.each{|index|                    
                        if self.[](index) != '\0'
                            temp.append(self.[](index))
                        end
                    }
                    temp.each{|element| result.push(yield(element))}
                    return result
                else
                    return []
                end
            else
                raise "Type error"
                return
            end
         return result
        end
    end
end
b =	["CAT", 'DOG', 'HELLO']
print b.map(-3..-1){|i|	i.downcase} 


# x = (-20..10)
# y = (-6..5)
# print (x.to_a & y.to_a).empty?