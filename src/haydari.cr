require "./haydari/*"
require "./haydari/parsers/*"

module Haydari
    def text(parser)
        select parser, &.join
    end

    def any
        SatisfyParser.new { true }
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

    def return(val)
        ReturnParser.new val
    end

    def ws
        SatisfyParser.new &.whitespace?
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

    def one_of_c(s : String)
        SatisfyParserChar.new { |c| s.includes?(c) }
    end

    macro flatten(rest)
        {{"(".id}}{{rest}}{{").flatten".id}}
    end

    macro to(transformer, rest)
        {{"(".id}}{{rest}}{{")".id}}.select {{transformer.id}}
    end

    macro recurse(name)
        {{"ClosureParser.new(->self.".id}}{{name.id}}{{")".id}}
    end
end
