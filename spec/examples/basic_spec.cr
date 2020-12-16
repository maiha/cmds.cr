require "../spec_helper"

describe "(basic usage)" do
  it "delegates to command and task" do
    File.write("tmp/1.json", %({"foo": 42, "bar": 43}))
 
    run!("basic json pretty tmp/1.json").stdout.should eq <<-EOF
      {
        "foo": 42,
        "bar": 43
      }

      EOF
  end

  it "uses the first arg as `task_name`" do
    run!("basic json inspect").stdout.should eq <<-EOF
      task_name(before)=inspect
      task_name=inspect
      args=[]

      EOF
  end

  it "uses the rest args as `args`" do
    run!("basic json inspect 1 2").stdout.should eq <<-EOF
      task_name(before)=inspect
      task_name=inspect
      args=["1", "2"]

      EOF
  end
  
  it "exits with the message when abort is fired" do
    shell = run("basic json pretty")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should eq("specify file")
  end

  it "exits with the message" do
    shell = run("basic json fails")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should match(/unhandled error/)
  end
end

