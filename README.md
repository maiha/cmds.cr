# cmds.cr

Yet another CLI Builder library for [Crystal](http://crystal-lang.org/).
- crystal: 0.26.1

### features
- Simple and readable syntax for **command** and **task**
- Automatic generation of command candidates
- Automatic generation of task candidates
- Automatic generation of usages

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
Possible commands are: json

$ prog json
Error: unknown task: ''
Possible commands are: ["pretty"]
  ./prog json pretty file.json
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cmds:
    github: maiha/cmds.cr
    version: 0.1.0
```

## Usage

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
