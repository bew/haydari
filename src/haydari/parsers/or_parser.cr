require "../parser"

class Haydari::OrParser(T,U) < Haydari::Parser(T | U)
    def initialize(@parser1 : Parser(T), @parser2 : Parser(U))
        @output = [] of (T | U)
    end

    def reset
        @output = [] of (T | U)
        @parser1.reset
        @parser2.reset
    end

    def output
        @output[0]
    end

    def parse(input)
        input.mark

        if @parser1.run(input)
            input.unmark
            @output << T.cast(@parser1.output.not_nil!)
            return true
        end

        input.rewind
        input.mark

        if @parser2.run(input)
            input.unmark
            @output << U.cast(@parser2.output.not_nil!)
            return true
        end

        input.rewind

        false
    end
end

