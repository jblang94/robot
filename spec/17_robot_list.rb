require_relative 'spec_helper'

describe "Robot" do

  it "should keep track of all existing robots" do
    robot = Robot.new
    expect(Robot.robots.include?(robot)).to be true 
  end
  
end