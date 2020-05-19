require "../spec_helper"

describe "(without task)" do
  it "can define only commands by overwriting 'run' method" do
    run!("hello world").stdout.should eq <<-EOF
      (before)
      Hello world!
      (after)

      EOF
  end

  it "acceots arg" do
    run!("hello world foo").stdout.should eq <<-EOF
      (before)
      Hello world!
      ["foo"]
      (after)

      EOF
  end

  it "acceots args" do
    run!("hello world foo bar").stdout.should eq <<-EOF
      (before)
      Hello world!
      ["foo", "bar"]
      (after)

      EOF
  end
end
