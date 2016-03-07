require "../parser"

class Haydari::SatisfyParser < Haydari::Parser(Char)
    property predicate

    def initialize(&predicate : Char -> Bool)
        @output = '\0'
        @predicate = predicate
    end

    def reset
        @output = '\0'
    end

    def parse(input)
        return false if input.terminated?

        c = input.get_c

        if @predicate.call(c)
            @output = c
            input.success(c)
        else
            input.failure(c)
        end
    end
end

