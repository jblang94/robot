require 'spec_helper'

describe "Robot" do 

  before :each do
    @robot = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
  end

  describe "#throw_grenade" do
    it "should not affect robots that are outside of immediate surroundings" do
      expect(@robot2).to receive(:position).at_least(:once).and_return([-10,10])
      expect(@robot3).to receive(:position).at_least(:once).and_return([10,0])
      @robot.throw_grenade
      expect(@robot2.shield).to eq(Robot::MAX_SHIELD)
      expect(@robot3.shield).to eq(Robot::MAX_SHIELD)
    end

    it "should damage all robots in immediate surroundings by 30" do 
      expect(@robot2).to receive(:position).at_least(:once).and_return([-1,1])
      expect(@robot3).to receive(:position).at_least(:once).and_return([1,0])
      @robot.throw_grenade
      expect(@robot2.shield).to eq(Robot::MIN_SHIELD)
      expect(@robot3.shield).to eq(Robot::MIN_SHIELD)
    end

    it "should return nil if it has no grenades to throw" do
      allow(@robot).to receive(:grenades).and_return(0)
      expect(@robot.throw_grenade).to be nil
    end
  end

end