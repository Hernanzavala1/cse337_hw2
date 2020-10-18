class Console
  def initialize(player, narrator)
    @player   = player
    @narrator = narrator
  end

  def show_room_description
    @narrator.say "-----------------------------------------"
    @narrator.say "You are in room #{@player.room.number}."

    @player.explore_room

    @narrator.say "Exits go to: #{@player.room.exits.join(', ')}"
  end

  def ask_player_to_act
    actions = {"m" => :move, "s" => :shoot, "i" => :inspect }

    accepting_player_input do |command, room_number|
      @player.act(actions[command], @player.room.neighbor(room_number))
    end
  end

  private

  def accepting_player_input
    @narrator.say "-----------------------------------------"
    command = @narrator.ask("What do you want to do? (m)ove or (s)hoot?")

    unless ["m","s"].include?(command)
      @narrator.say "INVALID ACTION! TRY AGAIN!"
      return
    end

    dest = @narrator.ask("Where?").to_i

    unless @player.room.exits.include?(dest)
      @narrator.say "THERE IS NO PATH TO THAT ROOM! TRY AGAIN!"
      return
    end

    yield(command, dest)
  end
end

class Narrator
  def say(message)
    $stdout.puts message
  end

  def ask(question)
    print "#{question} "
    $stdin.gets.chomp
  end

  def tell_story
    yield until finished?

    say "-----------------------------------------"
    describe_ending
  end

  def finish_story(message)
    @ending_message = message
  end

  def finished?
    !!@ending_message
  end

  def describe_ending
    say @ending_message
  end
end
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
