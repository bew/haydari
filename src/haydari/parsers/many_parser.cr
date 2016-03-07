require "../parser"

class Haydari::ManyParser(T) < Haydari::Parser(Array(T))
    def initialize(@parser : Parser(T), @at_least = 0, @limit = Int32::MAX)
        @output = [] of T
    end

    def parse(input)
        while @parser.run(input) && @output.size < @limit
            @output << @parser.output
            @parser.reset
        end

        @output.size >= @at_least
    end

    def reset
        @output = [] of T
        @parser.reset
    end
end
