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

  it "exits with the message when abort is fired" do
    shell = run("basic json pretty")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should eq("specify file")
  end

  it "exits with the message and stacktrace when unhandled exception occurred" do
    shell = run("basic json fails")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should match(/unhandled error.*\n\s+from examples/)
  end

  it "fails with usages when the task name is wrong" do
    shell = run("basic json xxx")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).should eq <<-EOF
      Error: unknown task: 'xxx'
      Possible tasks are: ["fails", "pretty"]
        ./tmp/basic json pretty file.json
        ./tmp/basic json fails

      EOF
  end

  it "fails when the command name is wrong" do
    shell = run("basic foo")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).should eq <<-EOF
      Error: unknown command: 'foo'
      Possible commands are: ["json"]

      EOF
  end
end
