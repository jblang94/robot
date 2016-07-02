class BoxOfBolts < Item

  NAME = "Box of bolts"
  WEIGHT = 25
  PROVIDED_HEALTH = 20

  def initialize
    super(NAME, WEIGHT)
  end

  def feed(robot)
    robot.heal!(PROVIDED_HEALTH)
  end
end