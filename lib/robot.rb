class Robot

  DEFAULT_DAMAGE = 5
  DEFAULT_RANGE = 1
  DEFAULT_LATERAL_MOVE = 1
  DEFAULT_VERTICAL_MOVE = 1
  X_COORDINATE = 0
  Y_COORDINATE = 1
  INITIAL_X_COORDINATE = 0
  INITIAL_Y_COORDINATE = 0
  MAX_TOTAL_WEIGHT_OF_ITEMS = 250
  MAX_HEALTH = 100
  MIN_HEALTH = 0
  MAX_SHIELD = 50
  MIN_SHIELD = 0
  AUTO_HEAL_LIMIT = 80
  NO_WEAPON = nil

  @@robots = []

  attr_reader :position, :items, :health, :shield
  attr_accessor :equipped_weapon

  def initialize
    @position = [INITIAL_X_COORDINATE, INITIAL_Y_COORDINATE]
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
    position[X_COORDINATE] -= DEFAULT_LATERAL_MOVE
  end

  def move_right
    position[X_COORDINATE] += DEFAULT_LATERAL_MOVE
  end

  def move_up
    position[Y_COORDINATE] += DEFAULT_VERTICAL_MOVE
  end

  def move_down
    position[Y_COORDINATE] -= DEFAULT_VERTICAL_MOVE
  end

  def scan
    surroundings = positions_in_range(DEFAULT_RANGE)
    detections = []
    surroundings.each { |position| detections << self.class.in_position(position) }
    detections.flatten
  end

  def pick_up(item)
    if is_a_weapon?(item)
      self.equipped_weapon = item
    elsif item.is_a?(BoxOfBolts)
      return item.feed(self) if auto_heal_allowed?
    end
      items << item if within_capacity?(item)
  end

  def items_weight
    items.reduce(0) { |total_weight, item| total_weight + item.weight }
  end

  def wound!(damage_received)
    damage_remaining = damage_received
    if has_shield?
      damage_remaining = wound_shield!(damage_received)
      return if no_damage_remaining?(damage_remaining)
    end
    @health -= damage_remaining
    @health = MIN_HEALTH if below_min_health?
  end

  def heal!(regained_health)
    raise RobotAlreadyDeadError if dead?
    @health += regained_health
    @health = MAX_HEALTH if above_max_health?
  end

  def attack!(enemy)
    raise UnattackableEnemyError if not_a_robot?(enemy)
    raise RobotAlreadyDeadError if enemy_dead?(enemy)
    if has_equipped_weapon?
      attack_with_weapon!(enemy)
    else
      enemy.wound!(DEFAULT_DAMAGE) if in_range?(enemy, DEFAULT_RANGE)
    end
  end

  def heal_shield(recovered_shield)
    @shield += recovered_shield 
    @shield = MAX_SHIELD if above_max_shield?
  end

  private

  def has_shield?
    shield > MIN_SHIELD
  end

  def above_max_shield?
    @shield > MAX_SHIELD
  end

  def below_min_health?
    health < MIN_HEALTH
  end

  def above_max_health?
    @health > MAX_HEALTH
  end

  def auto_heal_allowed?
    health <= AUTO_HEAL_LIMIT
  end

  def dead?
    health == MIN_HEALTH
  end

  def enemy_dead?(enemy)
    enemy.health == MIN_HEALTH
  end

  def is_a_weapon?(item)
    item.is_a?(Weapon)
  end

  def within_capacity?(item)
    items_weight + item.weight <= MAX_TOTAL_WEIGHT_OF_ITEMS
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

  def no_damage_remaining?(damage_remaining)
    damage_remaining <= 0
  end

  def used_grenade?
    self.equipped_weapon.is_a?(Grenade)
  end

  def in_range?(enemy, max_range)
    (DEFAULT_RANGE..max_range).each do |range|
      return true if positions_in_range(range).include?(enemy.position)
    end
    false
  end

  def positions_in_range(range)
    [
      [@position[X_COORDINATE], @position[Y_COORDINATE] + range],
      [@position[X_COORDINATE], @position[Y_COORDINATE] - range],
      [@position[X_COORDINATE] + range, @position[Y_COORDINATE]],
      [@position[X_COORDINATE] - range, @position[Y_COORDINATE]],
    ]
  end

  def wound_shield!(damage_received)
    damage_remaining = damage_received - shield
    @shield -= damage_received
    @shield = MIN_SHIELD if shield < MIN_SHIELD
    damage_remaining
  end

  def attack_with_weapon!(enemy)
    if is_special_weapon?
        attack_with_special_weapon!(enemy)
    elsif in_range?(enemy, self.equipped_weapon.range)
        self.equipped_weapon.hit(enemy) 
        self.equipped_weapon = NO_WEAPON if used_grenade?
    end
  end

  def attack_with_special_weapon!(targetted_enemy)
    return unless in_range?(targetted_enemy, self.equipped_weapon.range)
    enemies_in_range = scan
    enemies_in_range.each { |enemy| self.equipped_weapon.hit(enemy) }
    self.equipped_weapon = NO_WEAPON
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