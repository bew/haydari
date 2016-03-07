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
        return parser.select { |t| BrainfuckToken.from_string(t.to_s) }
    end

    # Since Proc's return type is NoReturn for recursives recursion 
    # is disabled for now
    def parse_program
        start_t  = string("[").maybe
        commands = parse_command.many
        end_t    = string("]").maybe

        (start_t >> commands << end_t).select { |cmds| BrainfuckProgram.new cmds }
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
