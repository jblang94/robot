require_relative 'spec_helper'

describe Robot do

  before :each do
    @robot = Robot.new
  end

  describe "#heal!" do
    it "should not regain health if it is already dead" do
      allow(@robot).to receive(:health).and_return(Robot::MIN_HEALTH)
      expect{ @robot.heal!(100) }.to raise_error(RobotAlreadyDeadError)
    end

    it "should heal when it is alive and not at full health" do
      allow(@robot).to receive(:health).and_return(Robot::MAX_HEALTH/2)
      expect(@robot).to receive(:health).and_return(Robot::MAX_HEALTH)
      @robot.heal!(Robot::MAX_HEALTH/2)
    end

    it "should not heal when it is at full health" do
      allow(@robot).to receive(:health).and_return(Robot::MAX_HEALTH)
      @robot.heal!(Robot::MAX_HEALTH/2)
    end
  end

  describe "#attack!" do
    it "should not attack an enemy that is not a Robot" do
      expect{ @robot.attack!(Item.new("not a robot", 0)) }.to raise_error(UnattackableEnemyError)
    end

    it "should attack an enemy that is a Robot" do
      enemy = Robot.new
      expect(enemy).to receive(:wound).with(Robot::DEFAULT_DAMAGE)
      @robot.attack!(enemy)
    end
  end

end