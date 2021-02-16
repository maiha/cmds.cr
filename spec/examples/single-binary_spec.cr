require "../spec_helper"

describe "(single binary)" do
  it "(setup symlinks)" do
    Dir.cd("tmp") do
      shell = Shell::Seq.new
      shell.run("ln -sf single-binary one")
      shell.run("ln -sf single-binary two")
      shell.run("ln -sf single-binary three")
      shell.run("ln -sf single-binary xxx")
    end
  end

  it "one hello world" do
    run!("one hello world").stdout.chomp.should eq "1"
  end

  it "two hello world" do
    run!("two hello world").stdout.chomp.should eq "2"
  end

  it "three run" do
    run!("three run").stdout.should contain "run method"
  end

  it "xxx hello world" do
    shell = run("xxx hello world")
    shell.success?.should be_false
    shell.exit_code.should eq(127)
    shell.stderr.should contain "xxx: command not found"
  end

  it "one hello xxx" do
    shell = run("one hello xxx")
    shell.success?.should be_false
    shell.stderr.should contain "usage: one hello <task>"
  end

  it "one hello xxx" do
    shell = run("one hello xxx")
    shell.success?.should be_false
    shell.stderr.should contain "usage: one hello <task>"
  end

  it "one" do
    shell = run("one")
    shell.success?.should be_false
    shell.stderr.should contain "usage: one <command>"
  end

  it "three" do
    run("three").stderr.should contain "usage: three <command>"
  end
end
