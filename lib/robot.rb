class Robot

  MAX_TOTAL_WEIGHT_OF_ITEMS = 250
  MAX_HEALTH = 100
  MIN_HEALTH = 0
  MAX_SHIELD = 50
  MIN_SHIELD = 0
  MAX_GRENADES = 1
  DEFAULT_DAMAGE = 5

  @@robots = []

  attr_reader :position, :items, :health, :shield, :grenades
  attr_accessor :equipped_weapon

  def initialize
    @position = [0,0]
    @items = []
    @health = MAX_HEALTH
    @equipped_weapon = nil
    @shield = MAX_SHIELD
    @grenades = MAX_GRENADES
    @@robots << self
  end

  def self.robots
    @@robots
  end

  def self.in_position(coordinate)
    @@robots.select { |robot| robot.position == coordinate }
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def pick_up(item)
    if is_a_weapon?(item)
      self.equipped_weapon = item
    else
      unless items_at_capacity?
        @items << item if items_within_capacity?(item)
      end
    end
  end

  def items_weight
    @items.reduce(0) { |total_weight, item| total_weight + item.weight }
  end

  def wound(damage_received)
    @health -= damage_received
    @health = MIN_HEALTH if @health < MIN_HEALTH
  end

  def wound!(damage_received)
    if shield > MIN_SHIELD
      if damage_received > MAX_SHIELD
        damage_remaining = damage_received - @shield
        @health -= damage_remaining
        @health = MIN_HEALTH if @health < MIN_HEALTH
      end
      @shield -= damage_received
      @shield = MIN_SHIELD if @shield < MIN_SHIELD
    else
      @health -= damage_received
      @health = MIN_HEALTH if @health < MIN_HEALTH
    end
  end

  def heal(regained_health)
    @health += regained_health
    @health = MAX_HEALTH if @health > MAX_HEALTH
  end

  def heal!(regained_health)
    raise RobotAlreadyDeadError if dead?
    @health += regained_health
    @health = MAX_HEALTH if @health > MAX_HEALTH
  end

  def attack(enemy)
    if has_equipped_weapon?
      self.equipped_weapon.hit(enemy)
    else
      enemy.wound(DEFAULT_DAMAGE)
    end
  end

  def attack!(enemy)
    raise UnattackableEnemyError if not_a_robot?(enemy)
    if has_equipped_weapon?
      self.equipped_weapon.hit(enemy)
    else
      enemy.wound(DEFAULT_DAMAGE)
    end
  end

  def heal_shield(recovered_shield)
    @shield += recovered_shield 
    @shield = MAX_SHIELD if @shield > MAX_SHIELD
  end

  def scan
    surrondings_to_check = surrounding_coordinates
    scanning_results = []
    scanning_results << self.class.in_position(surrondings_to_check[:top])
    scanning_results << self.class.in_position(surrondings_to_check[:bottom])
    scanning_results << self.class.in_position(surrondings_to_check[:right])
    scanning_results << self.class.in_position(surrondings_to_check[:left])
    scanning_results << self.class.in_position(surrondings_to_check[:bottom_right])
    scanning_results << self.class.in_position(surrondings_to_check[:bottom_left])
    scanning_results << self.class.in_position(surrondings_to_check[:top_left])
    scanning_results << self.class.in_position(surrondings_to_check[:top_right])
    scanning_results.flatten
  end

  def throw_grenade
    return if already_used_grenade?
    targets = self.scan
    grenade = Grenade.new
    targets.each { |target| grenade.hit(target) }
  end

  private

  def items_at_capacity?
    items_weight == MAX_TOTAL_WEIGHT_OF_ITEMS
  end

  def items_within_capacity?(item)
    items_weight + item.weight <= MAX_TOTAL_WEIGHT_OF_ITEMS
  end

  def has_equipped_weapon?
    !self.equipped_weapon.nil?
  end

  def is_a_weapon?(item)
    item.is_a?(Weapon)
  end

  def dead?
    health == 0
  end

  def already_used_grenade?
    grenades == 0
  end

  def not_a_robot?(enemy)
    !enemy.is_a?(Robot)
  end

  def surrounding_coordinates
    {
      top: [@position[0],@position[1] + 1],
      bottom: [@position[0],@position[1] - 1],
      right: [@position[0] + 1,@position[1]],
      left: [@position[0] - 1,@position[1]],
      bottom_right: [@position[0] + 1,@position[1] - 1],
      bottom_left: [@position[0] - 1,@position[1] - 1],
      top_right: [@position[0] + 1,@position[1] + 1],
      top_left: [@position[0] - 1,@position[1] + 1]
    }
  end

end

class RobotAlreadyDeadError < StandardError

  def initialize(msg="Robot is already dead!")
    super
  end

end

class UnattackableEnemyError < StandardError

  def initialize(msg="Cannot attack an enemy that is not a Robot")
    super
  end

end