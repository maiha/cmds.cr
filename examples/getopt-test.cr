require "../src/cmds"

Cmds.command "math" do
  task "incr" do
    value = getopt_i32("--value=")
    by    = getopt_i32?("--by=") || 1
    debug = getopt_b("-d", false)

    if debug
      puts "#{value} + #{by}"
    end

    puts value + by
  end
end

Cmds.run
