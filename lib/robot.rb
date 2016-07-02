class Robot

  MAX_TOTAL_WEIGHT_OF_ITEMS = 250
  MAX_HEALTH = 100
  MIN_HEALTH = 0
  AUTO_HEAL_LIMIT = 80
  MAX_SHIELD = 50
  MIN_SHIELD = 0
  NO_WEAPON = nil
  DEFAULT_DAMAGE = 5
  DEFAULT_RANGE = 1

  @@robots = []

  attr_reader :position, :items, :health, :shield
  attr_accessor :equipped_weapon

  def initialize
    @position = [0,0]
    @items = []
    @health = MAX_HEALTH
    @equipped_weapon = NO_WEAPON
    @shield = MAX_SHIELD
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

  def scan
    surroundings_to_check = positions_from_offset(1)
    scanning_results = []
    surroundings_to_check.each_value { |position| scanning_results << self.class.in_position(position) }
    scanning_results.flatten
  end

  def pick_up(item)
    if is_a_weapon?(item)
      self.equipped_weapon = item
    elsif item.is_a?(BoxOfBolts)
      return item.feed(self) if health <= AUTO_HEAL_LIMIT
    end
      @items << item if within_capacity?(item)
  end

  def items_weight
    @items.reduce(0) { |total_weight, item| total_weight + item.weight }
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

  def heal!(regained_health)
    raise RobotAlreadyDeadError if dead?
    @health += regained_health
    @health = MAX_HEALTH if @health > MAX_HEALTH
  end

  def attack!(enemy)
    raise UnattackableEnemyError if not_a_robot?(enemy)
    if has_equipped_weapon?
      if is_special_weapon?
        attack_with_special_weapon!(enemy)
      else
        if in_range?(enemy, self.equipped_weapon.range)
          self.equipped_weapon.hit(enemy) 
          self.equipped_weapon = NO_WEAPON if used_grenade?
        end
      end
    else
      enemy.wound!(DEFAULT_DAMAGE) if in_range?(enemy, DEFAULT_RANGE)
    end
  end

  def heal_shield(recovered_shield)
    @shield += recovered_shield 
    @shield = MAX_SHIELD if @shield > MAX_SHIELD
  end

  ######### => HELPER FUNCTIONS => ###########
  private

  def attack_with_special_weapon!(targetted_enemy)
    return unless in_range?(targetted_enemy, self.equipped_weapon.range)
    enemies_in_range = scan
    enemies_in_range.each { |enemy| self.equipped_weapon.hit(enemy) }
    self.equipped_weapon = NO_WEAPON
  end

  # Returns an Array of Hashes which contain all of the positions within a given range
  def coordinates_in_range(range)
    coordinates = []
    (1..range).each { |offset| coordinates << positions_from_offset(offset) }
    coordinates
  end

  def in_range?(enemy, range)
    (1..range).each do |offset|
      return true if positions_from_offset(offset).has_value?(enemy.position)
    end
    false
  end

  def within_capacity?(item)
    items_weight + item.weight <= MAX_TOTAL_WEIGHT_OF_ITEMS
  end

  def is_a_weapon?(item)
    item.is_a?(Weapon)
  end

  def dead?
    health == MIN_HEALTH
  end

  def not_a_robot?(enemy)
    !enemy.is_a?(Robot)
  end

  def has_equipped_weapon?
    self.equipped_weapon != NO_WEAPON
  end

  def is_special_weapon?
    self.equipped_weapon.is_a?(SpecialWeapon)
  end

  def used_grenade?
    self.equipped_weapon.is_a?(Grenade)
  end

  def positions_from_offset(offset)
    {
      top: [@position[0], @position[1] + offset],
      bottom: [@position[0], @position[1] - offset],
      right: [@position[0] + offset, @position[1]],
      left: [@position[0] - offset, @position[1]],
      bottom_right: [@position[0] + offset, @position[1] - offset],
      bottom_left: [@position[0] - offset, @position[1] - offset],
      top_right: [@position[0] + offset, @position[1] + offset],
      top_left: [@position[0] - offset, @position[1] + offset]
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