
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
        already_evaluated = Array.new(self.size, false)
        if sequence == nil
            # call the old map 
            return self.oldMap(&block) 
        else 
            if sequence.class == Range && block_given? && sequence.all? { |x| x.is_a? Integer }
                beginning  = self.size * -1
                end_index = self.size - 1 
                valid_indices = Range.new(beginning, end_index)
                common_indices = (sequence.to_a & valid_indices.to_a)
                if common_indices.empty? == false
                    common_indices.each{|index|                    
                            temp.append(self.[](index))                    
                    }
                    temp.each_with_index{|element, index|
                        if   already_evaluated[index] == false 
                            already_evaluated[index] = true
                            result.push(yield(element))
                        end
                    }
                    return result
                else
                    return []
                end
            else
                raise "Type error"
                return
            end
        end
    end
end
