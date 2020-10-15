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
    end
    attr_reader :rooms
end

cave = Cave.dodecahedron
rooms = (1..20).map { |i| cave.room(i)}
rooms.each do |room|
 print room.neighbors.count == 3, "\n"
 room.neighbors.each { |i|
print i.neighbors.include?(room) == true , "\n"
 }
end

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
