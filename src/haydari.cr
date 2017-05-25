require "./haydari/*"
require "./haydari/parsers/*"

module Haydari
    def text(parser)
      self.select parser, &.join
    end

    def number
        SatisfyParserString.new(&.digit?).at_least_one.text.select &.to_i
    end

    def any
        SatisfyParser.new { true }
    end

    def spaces
        ws.many
    end

    def char(c : Char)
        CharParser.new c
    end

    def word
        not(ws).at_least_one.select &.join
    end

    def digit
        SatisfyParserChar.new &.digit?
    end

    def string(str : String)
        StringParser.new(str)
    end

    def select(parser : Parser(T), &block : T -> U)
        ThenParser.new(parser) { |o| ReturnParser.new block.call(o) }
    end

    def or(parser, other : Parser(T))
        OrParser.new(parser, other)
    end

    def then(parser : Parser(T), &block : T -> U)
        ThenParser.new(parser, &block)
    end

    def then(&block : -> Parser(T))
        block.call()
    end

    def return_(val)
        ReturnParser.new val
    end

    def index_of(str : String)
        one_of(str).select &->str.index(String)
    end

    def token_c(str : String, val)
        StringParser.new(str) >> return_ val
    end

    def ws
        SatisfyParserString.new &.whitespace?
    end

    def not(p : Parser(T))
        NotParser(T).new p
    end

    def many(p : Parser(T))
        ManyParser(T).new(p)
    end

    def many1(p : Parser(T))
        ManyParser(T).new(p, 1)
    end

    def one_of(s : String)
        SatisfyParserString.new { |c| s.includes?(c) }
    end

    def none_of(s : String)
        SatisfyParserString.new { |c| !s.includes?(c) }
    end

    def one_of_c(s : String)
        SatisfyParserChar.new { |c| s.includes?(c) }
    end

    macro flatten(rest)
        {{"(".id}}{{rest}}{{").flatten".id}}
    end

    macro to(transformer, rest)
        {{"(".id}}{{rest}}{{")".id}}.select {{transformer.id}}
    end

    macro defparser(name, type, &block)
        class Parser___{{name}} < ParserGenerator({{type}})
            include Haydari

            def initialize(@owner : Haydari)
            end

            forward_missing_to @owner

            def {{name}}
                RecurseParser({{type}}).new(Parser___{{name}}.new(@owner))
            end

            def generate
                {{block.body}}
            end
        end

        def {{name}}
            RecurseParser({{type.id}}).new(Parser___{{name}}.new(self))
        end
    end
end
