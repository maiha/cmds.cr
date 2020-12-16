require "../spec_helper"

describe "(cli)" do
  it "raise ShowUsage globally" do
    run!("cli -h").stderr.should eq <<-EOF
      usage: cli <command> ...
      
      commands:
          show
      
      examples:
          cli show


      EOF
  end

  it "show_usage in cmd" do
    run!("cli show usage").stderr.should eq <<-EOF
      usage: cli show usage ...
      
      examples:
          cli show usage           # invoke show_usage in cmd
          cli show usage_with_msg  # invoke show_usage with msg in cmd


      EOF
  end

  it "show_usage(foo) in cmd" do
    run!("cli show usage_with_msg").stderr.should eq <<-EOF
      usage: cli show usage_with_msg ...
      
      examples:
          cli show usage           # invoke show_usage in cmd
          cli show usage_with_msg  # invoke show_usage with msg in cmd

      foo

      EOF
  end
end
      
      
