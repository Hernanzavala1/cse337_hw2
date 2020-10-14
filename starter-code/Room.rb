class Room
    def initialize(roomNum)
        @number = roomNum
        @hazards=[]
        @neighbors={}
        @exits = []
    end
    def has?(symbol)
        return @hazards.include?(symbol)
    end
    def add(symbol)
        @hazards.append(symbol)
    end
    def remove(symbol)
        @hazards.delete(symbol)
    end
    def empty?
        return @hazards.empty?
    end
    def connect(room)
        @neighbors[room.number] = room
        addExit(room.number)
        room.neighbors[@number] = self
        room.addExit(@number)
    end
    def addExit(exitNumber)
        @exits.append(exitNumber)
    end
    def neighbor(index)
        return @neighbors[index]
    end
    def random_neighbor
        values =@neighbors.values
        return values[rand(values.size)] 
    end
    def safeNeighbors
        result = true
        @neighbors.each {
            |key, value|
            if value.hazards.length > 0
                return false
            end
        }
        return result
    end
    def safe?
        if @hazards.length == 0 && safeNeighbors
            return true
        else 
            return false
        end
    end

    attr_reader :number, :hazards, :neighbors, :exits
end
room = Room.new(1)
exit_numbers = [11, 3, 7]
exit_numbers.each { |i|
room.connect(Room.new(i))
}
# print exit_numbers.include?(room.random_neighbor.number)
# neighbor = room.neighbors[7]
# neighbor.neighbors.each{
# |key, value|
# puts "#{key}:#{value}"
# }
# exit_numbers.each { |i|
#     print room.neighbor(i).number == i, "\n"
#     print room.neighbor(i).neighbor(room.number) == room , "\n"
#     }

room = Room.new(9)
print room.safe?, "\n"