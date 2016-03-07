require "../parser"

class Haydari::PlusParser(T,U) < Haydari::Parser(Array(T | U))
    def initialize(@parser1 : Parser(T), @parser2 : Parser(U))
        @output = [] of T | U
        @mergeable = false
    end

    def reset
        @parser1.reset
        @parser2.reset
    end

    def parse(input)
        input.mark

        if @parser1.parse(input)
            if @parser2.parse(input)
                input.unmark

                @output << @parser1.output.not_nil!
                @output << @parser2.output.not_nil!

                return true
            end
        end

        input.rewind
        return false
    end
end

