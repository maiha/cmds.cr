class Cmds::CmdTable
  @cmds = Hash(String, Cmd.class).new

  def resolve(name)
    if cmd = resolve?(name.to_s)
      return cmd
    elsif name.to_s.size > 0
      raise InvalidCommand.new(command: name.to_s)
    else
      raise MissingCommand.new
    end
  end  

  def resolve?(name)
    @cmds[name.to_s]?
  end

  forward_missing_to @cmds
end

