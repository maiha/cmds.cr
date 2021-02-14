require "../spec_helper"

describe "(getopt)" do
  it "getopt_i32" do
    run!("getopt-test math incr --value 1").stdout.chomp.should eq <<-EOF
      2
      EOF

    run!("getopt-test math incr --value 1 --by 3").stdout.chomp.should eq <<-EOF
      4
      EOF
  end

  it "getopt_b" do
    run!("getopt-test math incr --value 1 -d").stdout.chomp.should eq <<-EOF
      1 + 1
      2
      EOF
  end
end
      
