require_relative 'spec_helper'

describe "Robot" do

  before :each do
    @robot = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
  end  

  describe "#scan" do
    it "should return the robots that are immediately next to its current position" do
      expect(@robot2).to receive(:position).at_least(:once).and_return([-1,0])
      expect(@robot3).to receive(:position).at_least(:once).and_return([1,0])
      expect(@robot.scan.include?(@robot2)).to be true
      expect(@robot.scan.include?(@robot3)).to be true
    end

    it "should return an an empty array if nothing is detected" do
      expect(@robot2).to receive(:position).at_least(:once).and_return([-10,10])
      expect(@robot3).to receive(:position).at_least(:once).and_return([10,0])
      expect(@robot.scan).to eq([])
    end
  end
  
end