require "./spec_helper"

Cmds.command "usage_sample" do
  usage "get <KEY>       # Get the value of key"
  usage "set <KEY> <VAL> # Set key to hold the string value"
end

describe "Cmds::Cmd.pretty_usage" do
  it "builds a string for 'usage'" do
    usage = Cmds["usage_sample"].pretty_usage
    usage = usage.gsub(PROGRAM_NAME, "prog") # replace compile time string to 'prog'
    usage.should eq <<-EOF
      prog usage_sample get <KEY>       # Get the value of key
      prog usage_sample set <KEY> <VAL> # Set key to hold the string value
      EOF
  end

  it "respects prefix and delimiter" do
    usage = Cmds["usage_sample"].pretty_usage(prefix: "+-- ", delimiter: " | ")
    usage = usage.gsub(PROGRAM_NAME, "prog") # replace compile time string to 'prog'
    usage.should eq <<-EOF
      +-- prog | usage_sample | get <KEY>       # Get the value of key
      +-- prog | usage_sample | set <KEY> <VAL> # Set key to hold the string value
      EOF
  end
end
