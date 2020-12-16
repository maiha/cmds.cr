require "../spec_helper"

describe "navigate" do
  it "MissingCommand" do
    shell = run("navigate")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).strip.should eq <<-EOF
      usage: navigate <command> ...
             navigate ^^^^^^^^^

      commands:
          calc, todo, web

      examples:
          navigate calc
          navigate todo  # manage TODO list
          navigate web   # web server

      missing <command>.
      EOF
  end

  it "InvalidCommand" do
    shell = run("navigate xxx")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).strip.should eq <<-EOF
      usage: navigate <command> ...
             navigate xxx
      
      commands:
          calc, todo, web

      examples:
          navigate calc
          navigate todo  # manage TODO list
          navigate web   # web server

      invalid command: 'xxx'
      EOF
  end

  it "MissingTask" do
    shell = run("navigate web")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).strip.should eq <<-EOF
      usage: navigate web <task> ...
             navigate web ^^^^^^
      
      tasks:
          run, start, stop

      examples:
          navigate web run   0.0.0.0:8180 # run http server
          navigate web start 0.0.0.0:8180 # start http server
          navigate web stop               # stop http server

      missing <task>.
      EOF
  end

  it "InvalidTask" do
    shell = run("navigate web xxx")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).strip.should eq <<-EOF
      usage: navigate web <task> ...
             navigate web xxx
      
      tasks:
          run, start, stop

      examples:
          navigate web run   0.0.0.0:8180 # run http server
          navigate web start 0.0.0.0:8180 # start http server
          navigate web stop               # stop http server

      invalid task: 'xxx'
      EOF
  end

  it "MissingArgument" do
    shell = run("navigate web run")
    shell.success?.should be_false
    remove_ansi_color(shell.stderr).strip.should eq <<-EOF
      usage: navigate web run <bind>
             navigate web run 

      examples:
          navigate web run 0.0.0.0:8180 # run http server

      Specify the address and port to listen.
      EOF
  end
end
