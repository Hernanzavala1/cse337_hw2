# a = [1, 2, 34,5]
# print a.size
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
        # if i.class == Range
        #     start = i.begin
        #     endIndex = i.end
        #     if start < lowerBound || endIndex > upperBound
        #         # return self
        #         return '\0'
        #     else 
        #         return old(i)
        #     end
        # end
       
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

a	=	[1,2,34,5]
puts a[1]
puts a[10]	
#  a.map(2..4)	{|i|i.to_f}	
c = a.map	{	|i|	i.to_f}	
print c.to_a, "\n"


# b	=	["cat","bat","mat","sat"]
# b[-1]	=	"sat"
# b[5]	=	'\0'
# b.map(2..10)	{	|x|	x[0].upcase	+	x[1,x.length]	}	
#  b.map(2..4) {	|x|	x[0].upcase	+	x[1,x.length]	}	
#  b.map(-3..-1) {	|x|	x[0].upcase	+ x[1,x.length]	}	
# c = b.map{|x|x[0].upcase + x[1,x.length]}		
# print c.to_a

# b.map	{	|x|	x[0].upcase	+	x[1,x.length]	}
# print "\n"
# print a[10]	
# puts 
# b	=	["cat","bat","mat","sat"]
# puts b[-1]	
# puts b[5]	
