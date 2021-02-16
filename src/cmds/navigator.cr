module Cmds
  class Navigator
    var colorize : Bool = true
    var program  : String = File.basename(PROGRAM_NAME)

    var default : Hash(String, String) = {
      "program"  => program,
      "commands" => Cmds.names.join(", "),
    }

    def navigate(template : String, vars = Hash(String, String).new) : String
      buf = template
      cmd = Cmds.cmd_table.resolve?(vars["command"]?)

      no_examples_message = "    -- no examples --"
      
      template.scan(/{([a-z0-9_]+)}/) do
        key    = $1
        target = "{#{key}}"
        value  = nil
        case key
        when "msg"
          value = vars["msg"]?.to_s
        when "tasks"
          if cmd
            value = cmd.task_names.join(", ")
          end
        when "descs"
          if cmd
            if descs = cmd.descs[vars["task"]?.to_s]?
              value = build_descs(cmd, descs)
            end
          end
          value ||= ""
        when "commands_usages"
          lines = Array(Array(String)).new
          Cmds.names.each do |cmd_name|
            klass = Cmds.cmd_table.resolve(cmd_name)
            ary = [program, cmd_name]
            if first_usage = klass.usages[0]?
              ary << first_usage.text
            end
            lines << ary
          end
          value = pretty_lines(lines)
        when "this_descs"
          if cmd
            lines = Array(Array(String)).new
            descs = cmd.descs
            descs.keys.sort.each do |task_name|
              descs[task_name].each do |desc|
                lines << [program, cmd.cmd_name, desc.task, desc.text]
              end
            end
            value = pretty_lines(lines)
          end
          value = no_examples_message if value.to_s.empty?
        when "this_task_descs"
          if cmd
            lines = Array(Array(String)).new
            if descs = cmd.descs[vars["task"]?.to_s]?
              descs.each do |desc|
                lines << [program, cmd.cmd_name, desc.task, desc.text]
              end
            end
            value = pretty_lines(lines)
          end
          value = no_examples_message if value.to_s.empty?
        when "examples"
          if cmd
            if descs = cmd.descs[vars["task"]?.to_s]?
              value = build_examples(cmd, descs)
            end
          end
          value = no_examples_message if value.to_s.empty?
        else    
          value = vars[key]? || default[key]?
        end
        if value
          buf = buf.gsub(target, value)
        end
      end
      return buf
    end

    def navigate(err : Navigatable) : String
      navigate(err.template, err.vars)
    end

    def build_descs(cmd : Cmd.class, descs : Array(Desc)) : String
      lines = Array(Array(String)).new
      descs.each do |desc|
        lines << [program, cmd.cmd_name, desc.task, desc.text]
      end
      Pretty.lines(lines, indent: "  ", delimiter: " ")
    end

    def build_examples(cmd : Cmd.class, descs : Array(Desc)) : String
      if descs.any?
        String.build do |s|
          s.puts "examples:"
          s.puts build_descs(cmd, descs)
          s.puts
        end
      else
        ""
      end
    end

    private def pretty_lines(lines)
      Pretty.lines(lines: comment_splitter(lines), delimiter: " ", indent: "    ").gsub(/\s+$/m, "")
    end
    
    private def comment_splitter(lines : Array(Array(String)), splitter : Regex = /\s*#\s*/) :  Array(Array(String))
      return lines if lines.empty?
      index = [lines.map(&.size).max - 1, 0].max

      result = Array(Array(String)).new
      lines.each do |cols|
        left   = cols[0...index]
        target = cols[index]?
        if target
          parts   = target.split(splitter, 2)
          text    = parts[0]?.to_s
          comment = parts[1]? ? "# #{parts[1]?}" : ""
          right = [text, comment]
        else
          right = cols[index..-1]
        end
        result << (left + right)
      end
      return result
    end

  end
end
