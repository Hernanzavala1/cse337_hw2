load "./Room.rb"
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

cave = Cave.dodecahedron
cave.add_hazard(:guard, 1)
cave.add_hazard(:pit, 3)
cave.add_hazard(:bats, 3)
entrance = cave.entrance
puts entrance.safe? == true
entrance.neighbors.each{
    |x|
    puts x.hazards.size , " neightbors hazards size"
}

# rooms = (1..20).map { |i| cave.room(i)}
# rooms.each do |room|
#  print room.neighbors.count == 3, "\n"
#  room.neighbors.each { |i|
# print i.neighbors.include?(room) == true , "\n"
#  }
# end

#test the dedoblabla pattern
# rooms= cave.rooms
# rooms.each{
#     |room|
#     print room.number , "-- neighbors \n"
#     room.neighbors.each{
#         |x|
#         print x.number ,  ' '
#     }
#     puts
# }
