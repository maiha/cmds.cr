require "./spec_helper"

describe "Cmds::Navigatable" do
  it "MissingCommand is a Navigatable" do
    missing = Cmds::MissingCommand.new
    missing.should be_a(Cmds::Navigatable)
  end

  it "can navigate" do
    missing = Cmds::MissingCommand.new
    missing.navigate.should be_a(String)
  end
end
