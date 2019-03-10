require "../spec_helper"

describe "(logging)" do
  it "provides shortcuts #info, #debug" do
    run!("logging shortcuts").stdout.should eq <<-EOF
      INFO,foo
      DEBUG,bar

      EOF
  end
end
