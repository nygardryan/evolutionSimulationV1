class Creature
  attr_accessor :xValue, :yValue, :movementSpeed, :sight, :stomach, :metabolism, :hatchTime, :xBias, :yBias, :type, :health, :attackDamage, :fearDistance, :parentalGiving, :hatchingAmount, :selfishness, :stamina, :staminaMax, :staminaRegen, :running
  def initialize(x,y, color)
    @body = Rectangle.new(x: x, y: y, width: 5, height: 5, z: 0, color: color)
    @movementSpeed = rand(0.1..3)
    @sight = rand(1..150)
    @stomach = 120
    @hatchTime = rand(1.0..1000)
    @type = 'herbivore'
    @health = rand(1..30)
    @attackDamage = rand(1..10)
    @fearDistance = rand(1..30)
    @parentalGiving = rand(1..400)
    @selfishness = rand(1..700)
    @stamina = 300.0
    @staminaMax = rand(1..600)
    @staminaRegen = rand(1..30)
    @yBias = 0
    @xBias = 0
    @metabolism = 1.0
    @hatchingAmount = 0
    # @movementSpeed = 1
    # @sight = 30
    # @stomach = 200.0
    # @hatchTime = 300
    # @yBias = 0
    # @xBias = 0
    # @type = 'herbivore'
    # @health = 10
    # @attackDamage = 2
    # @fearDistance = 10
    # @parentalGiving = 200
    # @selfishness = 350
    # @stamina = 300
    # @staminaMax = 300
    # @staminaRegen = 10
    @running = true
    updateMetabolism
  end

  def updateMetabolism
    @metabolism = 0.10 + (@sight * 0.001) + (@movementSpeed * 0.025) + (@health * 0.015) + (@attackDamage * 0.015)
  end

  def metabolize
    @stomach = @stomach - @metabolism
  end

  def bodyClear
    @body.remove
  end

  def moveX(amount)
    @body.x += amount
  end
  def moveY(amount)
    @body.y += amount
  end

    def search(foodArray)
        @sortedArray = []
      if foodArray == []
       move
      else
          @sortedArray = foodArray.sort do |a, b|
            (a.xValue - @body.x).abs + (a.yValue - @body.y).abs <=> (b.xValue - @body.x).abs + (b.yValue - @body.y).abs
          end
          target = @sortedArray.first
          if (@body.x - target.xValue + @body.y - target.yValue) < @sight
            chase(target, foodArray)
          else
            move
          end
        end
      end

    def chase(food, foodArray)
      if food.xValue > @body.x
        @body.x += @movementSpeed
      end
      if food.xValue < @body.x
        @body.x -= @movementSpeed
      end
      if food.yValue > @body.y
        @body.y += @movementSpeed
      end
      if food.yValue < @body.y
        @body.y -= @movementSpeed
      end
      if (food.xValue - @body.x).abs < 3 && (food.yValue - @body.y).abs < 4
        combat(food, foodArray)
      end
    end

  def combat(food, foodArray)
      food.health -= @attackDamage  
    if food.health < 0
      @stomach += food.stomach
      food.bodyClear
      foodArray.delete(food)
    end
  end

  def move
    randomness = rand(-100..100)
    if randomness + @xBias > 50
      @body.x += @movementSpeed
    elsif randomness + @xBias < 50 && randomness + @xBias > 0
      @body.x -= @movementSpeed
    elsif randomness - @yBias > -50.0 && randomness + @yBias < 0
      @body.y += @movementSpeed
    elsif randomness - @yBias < -50.0
      @body.y -= @movementSpeed
    end
  end

  def reproduce(eggs)
    if @stomach >= @selfishness && @stomach >= @parentalGiving && @stomach > 5
      @stomach -= (@parentalGiving).abs + 100
      baby = Creature.new(xValue, yValue, "white")
      baby.movementSpeed, baby.sight, baby.stomach, baby.hatchTime, baby.xBias, baby.yBias, baby.type, baby.health, baby.attackDamage, baby.fearDistance, baby.selfishness, baby.parentalGiving, baby.staminaMax, baby.staminaRegen = @movementSpeed += rand(-0.2..0.2), @sight + rand(-3..3), @parentalGiving, @hatchTime + rand(-30..30), @xBias + rand(-2..2), @yBias + rand(-2..2), @type, @health + rand(-1.0..1.0), @attackDamage + rand(-0.5..0.5), @fearDistance, @selfishness + rand(-20.0..20.0), @parentalGiving + rand(-20.0..20.0), @staminaMax + rand(-10..10), @staminaRegen + rand(-0.5..0.5)
      baby.updateMetabolism
      eggs << baby
    end
  end
    def hatch
      @hatchingAmount += 1
    end

    def xValue
        @body.x
    end
    def yValue
        @body.y
    end
    def setXValue(value)
      @body.x = value
    end
    def setYValue(value)
      @body.y = value
    end

    def carnivoreColor
      @body.color = 'red'
    end    
    def herbivoreColor
      @body.color = 'yellow'
    end

    def outOfBounds
      if @body.x > 640
        @body.x = 10
      end
      if @body.x < 0
        @body.x = 630
      end
      if @body.y < 0
        @body.y = 470
      end
      if @body.y > 480
        @body.y = 10
    end
  end
end