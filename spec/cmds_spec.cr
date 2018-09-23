require "./spec_helper"

private def remove_ansi_color(buf : String) : String
  buf.gsub(/\e\[\d{1,3}[mK]/, "")
end

describe Cmds do
  it "delegates to command and task" do
    Pretty::Dir.clean("tmp")
    File.write("tmp/1.json", %({"foo": 42, "bar": 43}))
 
    shell = Shell::Seq.new
    shell.run("./prog json pretty tmp/1.json")
    shell.success?.should be_true
    shell.stdout.chomp.should eq <<-EOF
      {
        "foo": 42,
        "bar": 43
      }
      EOF
  end

  it "exits with the message when abort is fired" do
    shell = Shell::Seq.new
    shell.run("./prog json pretty")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should eq("specify file")
  end

  it "exits with the message and stacktrace when unhandled exception occurred" do
    shell = Shell::Seq.new
    shell.run("./prog json fails")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should match(/unhandled error.*\n  from examples/)
  end

  it "fails with usages when the task name is wrong" do
    shell = Shell::Seq.new
    shell.run("./prog json xxx")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should eq <<-EOF
      Error: unknown task: 'xxx'
      Possible commands are: ["fails", "pretty"]
        ./prog json pretty file.json
        ./prog json fails
      EOF
  end

  it "fails when the command name is wrong" do
    shell = Shell::Seq.new
    shell.run("./prog foo")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).chomp.should eq <<-EOF
      Error: unknown command: 'foo'
      Possible commands are: json
      EOF
  end
end
