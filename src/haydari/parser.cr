abstract class Haydari::Parser(T)
    protected setter output
    getter output

    def run(parser : Parser, input : ParserInput)
        run_parser(parser, input)
    end

    def run(input : ParserInput)
        run_parser(self, input)
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

    def not
        NotParser.new(self)
    end

    def flatten
        select &.flatten
    end

    def |(other : Parser(U))
        if self.is_a?(ParserOr)
            self.push_parser(other)
            self
        else
            OrParser.new([self, other])
        end
    end

    def +(other : Parser(U))
        PlusParser.new(self, other)
    end

    def <<(other : Parser(U))
        ThenParser.new(self) { |o| ThenParser.new(other) { |x| ReturnParser.new o } }
    end

    def >>(other : Parser(U))
        ThenParser.new(self) { |o| other }
    end

    private def run_parser(parser, input)
        parser.parse(input)
    end

    abstract def reset
    abstract def parse(input : ParserInput)
end


