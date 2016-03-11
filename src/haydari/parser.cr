abstract class Haydari::Parser(T)
    protected setter output
    getter output

    def run(parser : Parser, input : ParserInput)
        run_parser(parser, input)
    end

    def run(input : ParserInput)
        unless run_parser(self, input)
            return false
        end
        return true
    end

    def run(input_str : String)
        run_parser(self, ParserInput.new(input_str))
    end

    def select(&block : T -> U)
        ThenParser.new(self) { |o| ReturnParser.new block.call(o) }
    end

    def many(count = 0)
        ManyParser.new(self, count)
    end

    def maybe
        ManyParser.new(self, 0, 1)
    end

    def at_least_one
        ManyParser.new(self, 1)
    end

    def then(&block : T -> Parser(U))
        ThenParser.new(self) { |o| block.call(o) }
    end

    def return(val)
        ThenParser.new(self) { |_| ReturnParser.new val }
    end

    def text
        ThenParser.new(self) { |str_arr| ReturnParser.new str_arr.join }
    end

    def not
        NotParser.new(self)
    end

    def to_enum(type)
        ThenParser.new(self) { |o| ReturnParser.new type.new(o.not_nil!) }
    end

    def flatten
        select &.flatten
    end

    def sep(parser : Parser(U))
        SeparatedByParser.new(self, parser)
    end

    def |(other : Parser(T | U))
        OrParser.new(self, other)
    end

    def +(other : Parser(U))
        PlusParser.new(self, other)
    end

    def <<(other : Parser(U))
        ThenParser.new(self) { |o| ThenParser.new(other) { |x| ReturnParser.new o } }
    end

    def <<(str : String)
        self << StringParser.new(str)
    end

    def >>(other : Parser(U))
        ThenParser.new(self) { |o| other }
    end

    def >>(str : String)
        self >> StringParser.new(str)
    end

    private def run_parser(parser, input)
        parser.parse(input)
    end

    abstract def reset
    abstract def parse(input : ParserInput)
end


