
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
        if sequence == nil
            # call the old map 
            return self.oldMap(&block) 
        else 
            if sequence.class == Range && block_given?
                temp = slice(sequence)
                if temp == nil
                    return []
                end
                temp.each{|x| result.push(yield(x))}
            end
         return result
        end
    end
end
