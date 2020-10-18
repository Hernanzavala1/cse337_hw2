
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
            if sequence.class == Range && block_given? && sequence.all? { |x| x.is_a? Integer }
                temp = slice(sequence)
                if temp == nil
                    return []
                end
                temp.each{|x| result.push(yield(x))}
            else
                raise "Type error"
                return
            end
         return result
        end
    end
end
b = [1,2,3,4,5,6]
print b.map("a".."b"){|x| x + 1}, "\n"