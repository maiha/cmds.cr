require "../spec_helper"

describe "(args)" do
  it "works" do
    run!("args math sum 1 2").stdout.chomp.should eq <<-EOF
      3
      EOF
  end

  it "prints usage and missing position when arg not found" do
    run("args math sum 1").stderr.sub(/\s+\Z/m, "").should eq <<-EOF
      usage: ./tmp/args math sum a b
             ./tmp/args math sum 1 
                                   ^
      Arg2 not found
      EOF
  end

  it "prints usage and invalid position when arg not valid" do
    run("args math sum x 2").stderr.sub(/\s+\Z/m, "").should eq <<-EOF
      usage: ./tmp/args math sum a b
             ./tmp/args math sum x 2
                                 ^ 
      Invalid Int32: x
      EOF
  end
end
