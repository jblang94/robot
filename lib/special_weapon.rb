class SpecialWeapon < RangedWeapon

  NAME = "Special Weapon"
  WEIGHT = 40
  DAMAGE = 80
  RANGE = 1

  def initialize
    super(NAME, WEIGHT, DAMAGE, RANGE)
  end

end