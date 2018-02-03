require 'ruby2d'
require_relative 'creatures.rb'
require 'csv'

set title: "Evolution Simulation"
@tick = 0
@speedAverage, @sightAverage, @fearDistanceAverage, @eggTimeAverage, @herbivoreAmount, @parentalGivingAverage = ["Speed"], ["Sight"], ["fear Distance"], ["Egg Time"], ["# of individuals"], ["parentalGiving"]
@carnivoreSpeedAverage, @carnivoreSightAverage, @carnivoreFearDistanceAverage, @carnivoreEggTimeAverage, @carnivoreAmount, @carnivoreParentalGivingAverage = ["Speed"], ["Sight"], ["fear Distance"], ["Egg Time"], ["# of individuals"], ["parentalGiving"]

@creaturesHash = { :food => [], :herbivores => [], :carnivores => [], :eggs => []}

10.times do |x|
  x = Creature.new(rand(630),rand(480),"yellow")
  @creaturesHash[:herbivores].push(x) 
end
150.times do |x|
  x = Creature.new(rand(630),rand(470), "green")
  @creaturesHash[:food].push(x) 
end
# 10.times do |x|
#   x = Creature.new(rand(640),rand(480), "red")
#   @creaturesHash[:carnivores].push(x) 
# end


def csv_tool headers, data
  CSV.open('csvexperimentfile.csv', 'wb') do |csv|
    csv << headers

    data.each do |column|
      csv << column
    end
  end
end

headers = %w{Name Title Email}



on :key_up do |e|
crm_data = [
  ["Herbivores"],
  @herbivoreAmount,
  @speedAverage,
  @sightAverage,
  @fearDistanceAverage,
  @eggTimeAverage,
  @parentalGivingAverage,
  ["Carnivores"],
  @carnivoreAmount,
  @carnivoreSpeedAverage,
  @carnivoreSightAverage,
  @carnivoreFearDistanceAverage,
  @carnivoreEggTimeAverage,
  @carnivoreParentalGivingAverage,
]
  puts "averages created"
  csv_tool headers, crm_data
end



p @creaturesHash[:herbivores].length

update do
  if @tick % 3 && @creaturesHash[:food].length < 270
    @creaturesHash[:food] << Creature.new(rand(630),rand(470),"green")
  end
  @creaturesHash[:herbivores].each do |x|
    x.search(@creaturesHash[:food])
    x.metabolize
    x.outOfBounds
    x.reproduce(@creaturesHash[:eggs])
      if x.stomach < 0
        @creaturesHash[:herbivores].delete(x)
        x.bodyClear
      end
  end
  @creaturesHash[:carnivores].each do |x|
    x.search(@creaturesHash[:herbivores])
    x.metabolize
    x.outOfBounds
    x.reproduce(@creaturesHash[:eggs])
      if x.stomach < 0
        @creaturesHash[:carnivores].delete(x)
        x.bodyClear
      end
  end
  @creaturesHash[:eggs].each do |egg|
    egg.hatch
    if egg.hatchingAmount > egg.hatchTime
      if rand(1..100) <= 2
        if egg.type == 'herbivore'
          egg.type = 'carnivore'
        else
          egg.type = 'herbivore'
        end
      end
      if egg.type == 'herbivore'
        egg.herbivoreColor
        @creaturesHash[:herbivores] << egg
      elsif egg.type == 'carnivore'
        egg.carnivoreColor
        @creaturesHash[:carnivores] << egg
      end
      @creaturesHash[:eggs].delete(egg)
    end
  end

  if @tick % 60 == 0
    creatureAmount = 0

    speedAverage, sightAverage, fearDistanceAverage, eggTimeAverage, parentalGiving = 0.0, 0.0, 0.0, 0.0, 0.0
    @creaturesHash[:herbivores].each do |herbivore|
      creatureAmount += 1
      speedAverage += herbivore.movementSpeed
      sightAverage += herbivore.sight
      fearDistanceAverage += herbivore.fearDistance
      eggTimeAverage += herbivore.hatchTime
      parentalGiving += herbivore.parentalGiving
    end
    @creaturesHash[:eggs].each do |egg|
      if egg.type == "herbivore"
        creatureAmount += 1
        speedAverage += egg.movementSpeed
        sightAverage += egg.sight
        fearDistanceAverage += egg.fearDistance
        eggTimeAverage += egg.hatchTime
        parentalGiving += egg.parentalGiving
      end
    end
    speedAverage /= creatureAmount
    sightAverage /= creatureAmount
    fearDistanceAverage /= creatureAmount
    eggTimeAverage /= creatureAmount
    parentalGiving /= creatureAmount
    @herbivoreAmount << creatureAmount
    @speedAverage << speedAverage
    @sightAverage << sightAverage
    @fearDistanceAverage << fearDistanceAverage
    @eggTimeAverage << eggTimeAverage
    @parentalGivingAverage << parentalGiving


    creatureAmount = 0

    speedAverage, sightAverage, fearDistanceAverage, eggTimeAverage, parentalGiving = 0.0, 0.0, 0.0, 0.0, 0.0
    @creaturesHash[:carnivores].each do |carnivore|
      creatureAmount += 1
      speedAverage += carnivore.movementSpeed
      sightAverage += carnivore.sight
      fearDistanceAverage += carnivore.fearDistance
      eggTimeAverage += carnivore.hatchTime
      parentalGiving += carnivore.parentalGiving
    end
    @creaturesHash[:eggs].each do |egg|
      if egg.type == "carnivore"
        creatureAmount += 1
        speedAverage += egg.movementSpeed
        sightAverage += egg.sight
        fearDistanceAverage += egg.fearDistance
        eggTimeAverage += egg.hatchTime
        parentalGiving += egg.parentalGiving
      end
    end
    speedAverage /= creatureAmount
    sightAverage /= creatureAmount
    fearDistanceAverage /= creatureAmount
    eggTimeAverage /= creatureAmount
    parentalGiving /= creatureAmount
    @carnivoreAmount << creatureAmount
    @carnivoreSpeedAverage << speedAverage
    @carnivoreSightAverage << sightAverage
    @carnivoreFearDistanceAverage << fearDistanceAverage
    @carnivoreEggTimeAverage << eggTimeAverage
    @carnivoreParentalGivingAverage << parentalGiving
  end
  @tick += 1


      # unless @creaturesHash[:carnivores].empty? then p @creaturesHash[:carnivores][0].movementSpeed end
end
show


