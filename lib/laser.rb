class Laser < Weapon

  NAME = "Laser"
  WEIGHT = 125
  DAMAGE = 25
  RANGE = 1

  attr_reader :range

  def initialize
    super(NAME, WEIGHT, DAMAGE)
    @range = RANGE
  end

end