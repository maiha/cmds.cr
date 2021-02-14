# cmds.cr [![Build Status](https://travis-ci.org/maiha/cmds.cr.svg?branch=master)](https://travis-ci.org/maiha/cmds.cr)

> [Simple](#Simple) | [Tasks](#Tasks) | [Navigate](#Navigate) | [Args](#Args) | [Filter](#Filter)

A Crystal CLI library that absorbs most of the tedious processing required by the CLI and allows users to focus only on the essential logic.
- [crystal](http://crystal-lang.org/) : 0.27.2 0.31.1 0.32.1 0.33.0 0.34.0

### features
- Simple and readable syntax for **command** and **task**
- Multiple tasks for **sub commands**
- Auto-navigate when **commands** and **tasks** are not found
- Easy accessors for args
- Around filter to commands

## Simple

`Cmds.command` defines a new **command** and its `run` method is used for the main logic.
For example, **hello** command can be defined as follows.

```crystal
Cmds.command "hello" do
  def run
    puts "Hello world!"
  end
end

Cmds.run(ARGV)
```

```console
$ prog hello
Hello world!
```

## Tasks

When you want sub commands, it can be defined as **task** by `task` DSL.
For example, you can define a `pretty` **task** in the `json` **command** as follows.

```crystal
Cmds.command "json" do
  task "pretty" do
    path = args.shift? || abort "specify file"
    puts Pretty.json(File.read(path))
  end
end

Cmds.run(ARGV)
```

```console
$ echo "[1,2]" > foo.json
$ prog json pretty
specify file
$ prog json pretty foo.json
[
  1,
  2
]	
```

In this case, only one task is defined, but of course you can define multiple tasks with `task`.

## Navigate

If a **command** or **task** is not sufficiently specified, it will automatically navigate.
For example, if you call the above `prog` binary without args, it navigates possible commands.

```console
$ prog
usage: prog <command> ...
       prog ^^^^^^^^^

commands:
  json

missing <command>.
```

Then, it navigates tasks too.

```console
$ prog json
usage: prog json <task> ...
       prog json ^^^^^^

tasks:
  pretty

missing <task>.
```

## Args

- `args : Array(String)` presents CLI args
- `argN` like `arg1`, `arg2` is used for handy accessors

For example, in the case of a `sum` task that returns the addition of two arguments,
the `arg1` and `arg2` methods are available as follows.

```crystal
Cmds.command "math" do
  task "sum", "a b" do
    a = arg1(&.to_i)
    b = arg2(&.to_i)
    puts a + b
  end
end

Cmds.run
```

```console
$ prog math sum 1 2
3
```

Here, **"a b"** the second argument of the task definition is directly used as usage hint when navigating.

```console
$ prog math sum 1
usage: prog math sum a b
       prog math sum 1

missing <arg2>.
```

## getopt

```crystal
debug = getopt_b("-d", default: false)
host  = getopt_s?("--host=") || "localhost"
port  = getopt_i32?("--port=") || 80
```

## Filter

`before` and `after` methods will be automatically fired.
See [examples/hello.cr](./examples/hello.cr).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cmds:
    github: maiha/cmds.cr
    version: 0.3.8
```

```crystal
require "cmds"
```

## Development

```console
make ci
```

## Contributing

1. Fork it (<https://github.com/maiha/cmds.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
