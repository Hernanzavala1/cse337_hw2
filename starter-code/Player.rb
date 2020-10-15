require "./Room.rb"
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
        @current_room.neighbors.each{
        |neighbor|
        if !(neighbor.hazards.empty?)
            neighbor.hazards.each{
                |hazard|
                # @sensed[hazard].call # call the callback for the hazard 

            }
        end
        }
        
    end
    #we will get the hazard and a callback to that hazard
    def sense(symbol)
        # @sensed[symbol] = &block
        yield
    end
    def encounter(symbol)
        yield
        # @encounter[symbol] = &block
    end
    def action(symbol)
        # @actions[symbol] = &block
    end

end
player = Player.new
empty_room = Room.new(1)
guard_room = Room.new(2)
bats_room = Room.new(3)
room4 = Room.new(4)

sensed = Set.new()
encountered = Set.new()
empty_room.connect(guard_room)
empty_room.connect(bats_room)

player.sense(:bats) {sensed.add("You hear a rustling")}
player.sense(:guard) {sensed.add("You smell something terrible")}
player.encounter(:guard) {encountered.add("The guard killed you")}
player.encounter(:bats) { encountered.add("The bats whisked you away")}

player.enter(empty_room)
player.explore_room
puts sensed == Set["You hear a rustling", "You smell something
terrible"]
