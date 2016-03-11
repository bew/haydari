# haydari (WIP)

Parser combinator library for crystal-lang,

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  haydari:
    github: umurgdk/haydari
```

## TODO

- [ ] Support `IO` as `ParserInput`

## Usage
Parser combinators make easy to build complex parsers without dealing with so much hassle. Instead of trying to build one big monolithic parser, making small and composeable parsers and combining them together is way of writing parsers in parser combinators. Haydari gives you smallest parsers like *parse a character*, *parse a whitespace*, etc. and tons of combinators like *many*, *not*, *then* to give them a meaning.

### 1. Creating a parser

Let's start writing with simplest parser. Our parser going to read one **space** character and done.

```crystal
# samples/tutorial/1-char.cr
require "haydari"

class MyParser
    include Haydari

    defparser space, Char do
        char(' ')
    end
end

my_parser = MyParser.new.space
my_parser.run("       ")
puts "'#{my_parser.output}'" # prints a space character => ' '
```

Here `defparser` takes a **name** and a **type** of the value we're going to parse. Since we're using char parser it results in char value. As you can see calling space method is not running the parser, instead it builds a parser instance to run later on. 

But why we get only **one** space character even we pass a string which has more than one space characters? `char` parser reads a character from it's input and then success or fail. `char` parser don't know anything about how many times it should try to parse or what to do next. But **combinators** does. There are lots of combinators builtin Haydari but most known one is called `many`. `many` takes a parser and tries to run that parser until it fails. Let's parse multiple space characters.

```crystal
# samples/tutorial/2-many-chars.cr

# notice Array(Char)
defparser space, Array(Char) do
    many char(' ')
end
```

Now if we run our parser again output will be `'[' ', ' ', ' ']'`. First thing you should notice our parser's type is changed to `Array(Char)`. This is result of *many* combinator. *many* combinator takes a parser and run that parser until it fails and collect all the results. Because of that its value going to be array of values. You may expect `many char(' ')` to be resulted in `String`, but that's not true. Since *many* combinator could take any kind of parser, the parser you gave may not result into character.

### 2. Parsing comma separated array of strings

TBD

### JSON Parser

```crystal
require "haydari"

class JSONParser
    include Haydari

    alias JValue   = String | Int32 | Bool | Nil | Array(JValue) | Hash(String, JValue)
    alias KeyValue = {String, JValue}

    defparser string_lit, String do
        string("\"") >> none_of("\"\n").many.text << string("\"")
    end

    defparser bool_lit, Bool do
        string("true").return(true) | string("false").return(false)
    end

    defparser contents, JValue do
        string_lit | array_lit | object_lit | bool_lit | number
    end

    defparser comma, String do
        ws.many >> string(",") << ws.many
    end

    defparser array_lit, Array(JValue) do
        string("[") >> ws.many >> contents.sep(comma) << ws.many << string("]")
    end

    defparser key_value, KeyValue do
        string_lit.then { |key|
            ws.many >> string(":") >> ws.many >> contents.select { |value|
                {key, value}
            }
        }
    end

    defparser object_lit, Hash(String, JValue) do
        string("{") >> ws.many >> key_value.sep(comma).select { |kvs|
            hash = Hash(String, JValue).new
            kvs.each do |kv|
                hash[kv[0]] = kv[1]
            end
            hash
        } << ws.many << string("}")
    end

    def run(input)
        puts typeof(object_lit)
        parser = object_lit
        if parser.run(input)
            parser.output
        else
            raise "Failed!"
        end
    end
end

json_parser = JSONParser.new
hash = json_parser.run("{\"hello\" : \"world\", \"arr\":\n [1, 2, 3, true, {\"sub\"   : \"gell\"}]}")
puts hash.inspect
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
