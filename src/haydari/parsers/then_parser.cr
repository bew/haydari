require "../parser"

class Haydari::ThenParser(T,U) < Haydari::Parser(U)
    def initialize(@parser1 : Parser(T), &block : T -> Parser(U))
        @output = [] of U
        @parser2_fun = block
    end

    def reset
        @output = [] of U
        @parser1.reset
    end

    def output
        @output[0]
    end

    def parse(input)
        input.mark

        if @parser1.parse(input)
            parser2 = @parser2_fun.call(@parser1.output.not_nil!)
            parser2.reset

            if parser2.parse(input)
                input.unmark
                @output = [parser2.output.not_nil!]
                return true
            end
        end

        input.rewind
        return false
    end
end

