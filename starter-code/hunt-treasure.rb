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
    #check if the hazard is in the array first 
    def remove(symbol)
        if @hazards.include?(symbol)
             @hazards.delete(symbol)
        end
    end
    def empty?
        return @hazards.empty?
    end
    def getHash
        return @neighbors
    end
    def connect(room)
        @neighbors[room.number] = room
        addExit(room.number)
        room.getHash[@number] = self
        room.addExit(@number)
    end
    def addExit(exitNumber)
        @exits.append(exitNumber)
    end
    def neighbors
        return @neighbors.values
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
    attr_reader :number, :hazards, :exits
end

class Cave
    def initialize(rooms)
     @rooms = rooms
    end
     def self.dodecahedron
         rooms = Array.new(20){|i| Room.new(i+1)}
         rooms.each{|i|
         if i.number== 1 then i.connect(rooms[7]); i.connect(rooms[4]); i.connect(rooms[1])
         elsif i.number == 2 then i.connect(rooms[2]) ; i.connect(rooms[9])
         elsif i.number == 3 then i.connect(rooms[3]); i.connect(rooms[11])
         elsif i.number == 4 then i.connect(rooms[4]); i.connect(rooms[13])
         elsif i.number == 5 then i.connect(rooms[5])
         elsif i.number == 6 then i.connect(rooms[6]); i.connect(rooms[14])
         elsif i.number == 7 then i.connect(rooms[7]); i.connect(rooms[16])
         elsif i.number == 8 then i.connect(rooms[10])
         elsif i.number == 9 then i.connect(rooms[9]); i.connect(rooms[11]); i.connect(rooms[18])
         elsif i.number == 10 then i.connect(rooms[10])
         elsif i.number == 11 then i.connect(rooms[19])
         elsif i.number == 12 then i.connect(rooms[12])
         elsif i.number == 13 then i.connect(rooms[13]); i.connect(rooms[17])
         elsif i.number == 14 then i.connect(rooms[14])
         elsif i.number == 15 then i.connect(rooms[15])
         elsif i.number == 16 then i.connect(rooms[16]); i.connect(rooms[17])
         elsif i.number == 17 then i.connect(rooms[19])
         elsif i.number == 18 then i.connect(rooms[18])
         elsif i.number == 19 then i.connect(rooms[19])
             #20 already has all 3 neighbors
         end
         }
         return self.new(rooms)
     end
     def room(i)
       rooms[i-1]
     end
     def random_room
         return @rooms.sample
     end
     #TODO check for existence of the hazard in the new room and also check if the new_room is in the cave 
     def move(symbol, room, new_room)
         room.remove(symbol)
         new_room.add(symbol)
     end
     def add_hazard(symbol, number)
         count =0
         while count != number 
             room = random_room
             if !(room.has?(symbol))
                 room.add(symbol)
                 count += 1
             end 
         end
     end
 
     def room_with(symbol)
         result = @rooms.select{
             |room|
             room.has?(symbol)
         }
         if !(result.empty?) 
             return result[0]
         end
     end
     def entrance 
         @rooms.each {
             |room|
             if room.safe?
                 return room
             end
         }
     end
     attr_reader :rooms
     private :initialize
 end
require 'set'
class Player 
    def initialize()
        @sensed = {} # this is filled up in thee explore_room
        @encounter = {} # dictionary
        @actions = {} # dictionary of callbacks
        @current_room= nil
    end
    def enter(room)
        @current_room = room
    end
    
    #check neighbors for hazards and see if i can sense the hazard and what to print 
    def explore_room
        if !(@current_room.hazards.empty?)
            puts "this room has a hazard "
            @encounter[@current_room.hazards[0]].call
        end
        @current_room.neighbors.each{
        |neighbor|
        if neighbor.hazards.empty? == false
            neighbor.hazards.each{
                |hazard|
                @sensed[hazard].call # call the callback for the hazard 

            }
        end
        }
        
    end
    #we will get the hazard and a callback to that hazard
    def sense(symbol, &block)
        @sensed[symbol] = block
    end
    def encounter(symbol, &block)
        @encounter[symbol] = block
    end
    def action(symbol)
        # @actions[symbol] = &block
    end

end


