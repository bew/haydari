require "../parser"

class Haydari::ClosureParser(T) < Haydari::Parser(T)
    def initialize(generator : Proc(Parser(T)))
        @generator = generator
        @output = [] of T
    end

    def reset
        @output = [] of T
    end

    def output
        @output[0]
    end

    def parse(input)
        if generator = @generator
            parser = generator.call()

            if parser.parse(input)
                @output << parser.output.not_nil!
                true
            end

            false
        end

        false
    end
end

