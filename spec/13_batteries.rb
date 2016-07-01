require 'spec_helper'

describe "Battery" do

  before :each do 
    @battery = Battery.new
  end

  it "should be an Item" do
    expect(@battery).to be_an(Item)
  end

  it "should have ""Battery"" as its name" do
    expect(@battery.name).to eq("Battery")
  end

  it "should have a weight of 25" do
    expect(@battery.weight).to eq(25)
  end

  describe "#recharge" do
    it "should restore a Robot's shield by 25" do
      robot = Robot.new
      expect(robot).to receive(:heal_shield).with(Battery::PROVIDED_HEALTH)
      @battery.recharge(robot)
    end
  end

end