require "../spec_helper"

describe "(without task)" do
  it "can define only commands by overwriting 'run' method" do
    run!("hello world").stdout.should eq <<-EOF
      (before)
      Hello world!
      (after)

      EOF
  end
end
