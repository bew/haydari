require "../parser"

class Haydari::NotParser(T) < Haydari::Parser(Char)
    def initialize(@parser : Parser(Char))
        @output = '\0'
    end

    def reset
        @output = '\0'
        @parser.reset
    end

    def parse(input)
        return false if input.terminated?

        input.mark

        if @parser.run(input)
            input.rewind
            false
        else
            input.unmark
            char = input.get_c
            input.success(char)
            @output = char
            true
        end
    end
end

