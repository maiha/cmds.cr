require "../src/cmds"

Cmds.command "shortcuts" do
  def run
    logger.level = Logger::Severity::DEBUG
    info "foo"
    debug "bar"
  end

  protected def before
    logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
      io << severity.to_s << "," << message
    end
  end
end

Cmds.run

# ```console
# $ ./logging shortcuts
# INFO,foo
# DEBUG,bar
# ```
