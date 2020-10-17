class Room
    def initialize(roomNum)
        @number = roomNum
        @hazards=[]
        @neighbors={}
        @exits = []
    end
    def has?(symbol)
        if symbol != nil then return @hazards.include?(symbol) end
    end
    def add(symbol)
        if symbol != nil then @hazards.append(symbol) end
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
        return @neighbors.values.sample
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
       @rooms[i-1]
     end
     def random_room
         return @rooms.sample
     end
     #TODO check for existence of the hazard in the new room and also check if the new_room is in the cave 
     def move(symbol, room, new_room)
         room.remove(symbol)
         if !(new_room.has?(symbol))
         new_room.add(symbol)
         end
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
             room.has?(symbol) == true
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
#  cave = Cave.dodecahedron
#  rooms = cave.rooms
#  cave.add_hazard(:guard, 1)
# puts cave.room_with(:guard).has?(:guard) == true
# #  room = cave.random_room
# #  new_room = room.neighbors[1]
# #  room.add(:pit)
# #  puts room.has?(:pit)
# #  puts new_room.has?(:pit) 
# #  cave.move(:pit, room, new_room)
# #  puts room.has?(:pit) 
# #  puts new_room.has?(:pit) 

require 'set'
class Player 
    def initialize()
        @sensed = {} # this is filled up in thee explore_room
        @encounter = {} # dictionary
        @actions = {} # dictionary of callbacks
        @room = nil
    end
    def enter(room)
        @room  = room
        if room != nil && !(room.hazards.empty?)
            @encounter[room.hazards[0]].call
            return
        end
    end
    
    #check neighbors for hazards and see if i can sense the hazard and what to print 
    def explore_room
        @room.neighbors.each{
        |neighbor|
        if !(neighbor.hazards.empty?)
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
    def action(symbol, &block)
        @actions[symbol] = block
        
    end
    def act(symbol, room)
        if @actions[symbol] != nil
            @actions[symbol].call(room)
        end
    end
 attr_reader :room
end
# player = Player.new
# empty_room = Room.new(1)
# guard_room = Room.new(2)
# bats_room = Room.new(3)

# room4 = Room.new(4)
# sensed = Set.new
# encountered = Set.new

# empty_room.connect(guard_room)
# empty_room.connect(bats_room)

# player.sense(:bats) {sensed.add("You hear a rustling")}
# player.sense(:guard) {sensed.add("You smell something terrible")}
# player.encounter(:guard) {encountered.add("The guard killed you")}
# player.encounter(:bats) {encountered.add("The bats whisked you away")}

# player.action(:move) { |destination| player.enter(destination)}

# player.enter(empty_room)
# player.explore_room
# puts sensed == Set["You hear a rustling", "You smell something terrible"]
# puts encountered.empty? == true
# player = Player.new
# player.enter(bats_room)
# encountered == Set["The bats whisked you away"]
# puts sensed.empty? == true

# # player = Player.new
# player.act(:move, guard_room)
# puts player.room.number == guard_room.number , " move "
# puts encountered == Set["The guard killed you"]
# puts sensed.empty? == true
# player = Player.new
# player.enter(empty_room)
# puts player.room.number , " original room"
# player.action(:move) {|destination|player.enter(destination)}
# player.act(:move, guard_room)
# puts player.room.number , " new number"
# puts player.room.number == guard_room.number