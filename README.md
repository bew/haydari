# haydari (WIP)

Parser combinator library for crystal-lang,

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  haydari:
    github: umurgdk/haydari
```


## Usage


```crystal
require "haydari"

class BrainfuckParser
    include Haydari

    def parse_command
        parser = one_of("><+-.,")
        return parser.select { |t| BrainfuckTokens.from_string(t) }
    end

    def parse_program : Parser(BrainfuckProgram)
        start_t = string("[")
        
        commands_1   = parse_command.many
        sub_programs = recurse parse_program
        commands_2   = parse_command.many

        program      = commands_1 + sub_programs + commands_2
        program      = program.select { |p| BrainfuckProgram.new p.concat }

        end_t = string("]")

        (start_t > program < end_t)
    end

    def parse(input : String)
        parser = parse_program
        if parser.run(input)
            parser.output
        end
    end
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/umurgdk/haydari/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- umurgdk(https://github.com/umurgdk) Umur Gedik - creator, maintainer
