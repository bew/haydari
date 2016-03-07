require "../parser"

class Haydari::CharParser < Haydari::Parser(Char)
    property char

    def initialize(@char : Char)
        @output = '\0'
    end

    def reset
        @output = '\0'
    end

    def parse(input)
        return false if input.terminated?

        c = input.get_c

        if c == @char
            @output = c
            input.success(c)
        else
            input.failure(c)
        end
    end
end

