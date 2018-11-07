require "../spec_helper"

describe "(task_state)" do
  it "provides FINISHED when successfully done" do
    run("status emulate success").stdout.chomp.should eq("FINISHED")
  end

  it "provides FINISHED when finished! method is called" do
    run("status emulate finished").stdout.chomp.should eq("FINISHED")
  end

  it "provides RUNNING when an error has occurred" do
    run("status emulate failure").stdout.chomp.should eq("RUNNING")
  end
end
