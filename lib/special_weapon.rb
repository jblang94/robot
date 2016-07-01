class SpecialWeapon < Weapon

  NAME = "Special Weapon"
  WEIGHT = 40
  DAMAGE = 80
  RANGE = 1

  def initialize
    super(NAME, WEIGHT, DAMAGE)
  end

  def hit(robot)
    robot.wound!(@damage)
  end

end