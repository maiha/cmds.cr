# cmds.cr [![Build Status](https://travis-ci.org/maiha/cmds.cr.svg?branch=master)](https://travis-ci.org/maiha/cmds.cr)

Yet another CLI Builder library for [Crystal](http://crystal-lang.org/)
(0.26.1).

### features
- Simple and readable syntax for **command** and **task**
- Automatic generation of command candidates
- Automatic generation of task candidates
- Around filter to commands

## Usage

### hello world

Writing logics into `run` method provides a command.

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

### with args

- `args[0]` is automatically saved as `task_name`
- `args[1..-1]` can be used as `args`
- `argN` like `arg1`, `arg2` is used for handy accessors

See: [./examples/args.cr](./examples/args.cr)

### with tasks

Writing logics as `task` provides sub commands.

```crystal
Cmds.command "json" do
  usage "pretty file.json"

  task "pretty" do
    path = args.shift? || abort "specify file"
    puts Pretty.json(File.read(path))
  end
end

Cmds.run(ARGV)
```

```console
$ prog
Error: unknown command: ''
Possible commands are: ["json"]

$ prog json
Error: unknown task: ''
Possible tasks are: ["pretty"]
  prog json pretty file.json

$ prog json pretty
specify file
```

### around filter

`before` and `after` methods will be automatically fired.
See [examples/hello.cr](./examples/hello.cr).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cmds:
    github: maiha/cmds.cr
    version: 0.3.4
```

```crystal
require "cmds"
```

## Development

```console
make test
```

## Contributing

1. Fork it (<https://github.com/maiha/cmds.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
