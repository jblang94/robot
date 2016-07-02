class Grenade < RangedWeapon

  NAME = "Grenade"
  WEIGHT = 40
  DAMAGE = 15
  RANGE = 2

  def initialize
    super(NAME, WEIGHT, DAMAGE, RANGE)
  end

end