require 'spec_helper'

describe Robot do 

  before :each do
    @robot = Robot.new
  end

  it "should start off with 50 shield points" do
    expect(@robot.shield).to eql(Robot::MAX_SHIELD)
  end

  describe "#wound!" do
    it "should not affect health when the robot has a shield" do
      @robot.wound!(50)
      expect(@robot.shield).to eql(Robot::MIN_SHIELD)
      expect(@robot.health).to eql(Robot::MAX_HEALTH)
    end

    it "should affect health when the robot has no shield" do
      allow(@robot).to receive(:shield).and_return(Robot::MIN_SHIELD)
      @robot.wound!(50)
      expect(@robot.health).to eql(Robot::MAX_HEALTH - 50)
    end

    it "should affect health when the robot's shield is destroyed and there is remaining damage to be dealt" do
      @robot.wound!(150)
      expect(@robot.shield).to eql(Robot::MIN_SHIELD)
      expect(@robot.health).to eql(Robot::MIN_HEALTH)
    end
  end
  
end