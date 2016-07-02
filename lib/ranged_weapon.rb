class RangedWeapon < Weapon 

  attr_reader :range 

  def initialize(name, weight, damage, range)
    super(name, weight, damage)
    @range = range
  end

end