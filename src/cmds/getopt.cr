require "option_parser"

module Cmds::Getopt
  protected def getopt(flag : String)
    found  = nil
    valued = flag =~ /=/
    OptionParser.parse(args) do |parser|
      parser.invalid_option{|flag|}
      if valued
        parser.on(flag, flag) {|v| found = v}
      else
        parser.on(flag, flag) { found = true }
      end
    end

    return found
  end

  protected def getopt_b(flag : String, default : Bool) : Bool
    v = getopt(flag)
    if v == nil
      return default
    else
      return (!!v).as(Bool)
    end
  end

  protected def getopt_i32?(flag : String) : Int32?
    getopt_s?(flag).try(&.to_i32).as(Int32?)
  end

  protected def getopt_i32(flag : String, help : String? = nil) : Int32
    help ||= "No options for '#{flag}'"
    getopt_i32?(flag) || raise ArgumentError.new(help)
  end

  protected def getopt_s?(flag : String) : String?
    getopt(flag).as(String?)
  end

  protected def getopt_s(flag : String, help : String? = nil) : String
    help ||= "No options for '#{flag}'"
    getopt(flag).as(String?) || raise ArgumentError.new(help)
  end
end
