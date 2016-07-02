require 'spec_helper'

describe "Robot" do 

  before :each do
    @robot = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
    @robot.equipped_weapon = SpecialWeapon.new
  end

  describe "#attack!" do
    it "should not affect robots that are outside of immediate surroundings" do
      allow(@robot2).to receive(:position).at_least(:once).and_return([-10,10])
      allow(@robot3).to receive(:position).at_least(:once).and_return([10,0])
      @robot.attack!(@robot2)
      expect(@robot2.shield).to eq(Robot::MAX_SHIELD)
      expect(@robot3.shield).to eq(Robot::MAX_SHIELD)
    end

    it "should damage all robots in immediate surroundings by 30" do 
      expect(@robot2).to receive(:position).at_least(:once).and_return([-1,0])
      expect(@robot3).to receive(:position).at_least(:once).and_return([1,0])
      @robot.attack!(@robot2)
      expect(@robot2.shield).to eq(Robot::MIN_SHIELD)
      expect(@robot3.shield).to eq(Robot::MIN_SHIELD)
    end

    it "should dispense the special weapon as it is only single use" do
      expect(@robot2).to receive(:position).at_least(:once).and_return([-1,0])
      @robot.attack!(@robot2)
      expect(@robot.equipped_weapon).to be_nil
    end
  end

end