require_relative 'spec_helper'

describe "Robot" do 

  before :each do 
    @robot = Robot.new
    @robot2 = Robot.new
    @robot3 = Robot.new
  end

  describe ".in_position" do
    it "should return an empty array if there are no robots in a given (x,y) position" do
      test_coordinates = [10,20]
      expect(@robot2).to receive(:position).and_return(test_coordinates)
      expect(@robot3).to receive(:position).and_return(test_coordinates)
      expect(Robot.in_position(test_coordinates)).to eq([@robot2, @robot3])
    end

    it "should return an array of all robots that are in a given (x,y) position" do
      test_coordinates = [10,20]
      expect(Robot.in_position(test_coordinates)).to eq([])
    end
  end

end