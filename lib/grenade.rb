class Grenade < Weapon

  NAME = "Grenade"
  WEIGHT = 125
  DAMAGE = 80

  def initialize
    super(NAME, WEIGHT, DAMAGE)
  end

  def hit(robot)
    robot.wound!(@damage)
  end

end