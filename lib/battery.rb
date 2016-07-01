class Battery < Item

  NAME = "Battery"
  WEIGHT = 25
  PROVIDED_HEALTH = 25

  def initialize
    super(NAME, WEIGHT)
  end

  def recharge(robot)
    robot.heal_shield(PROVIDED_HEALTH)
  end

end