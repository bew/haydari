require "../parser"

class Haydari::SatisfyParserString < Haydari::Parser(String)
    property predicate

    def initialize(&predicate : Char -> Bool)
        @output = ""
        @predicate = predicate
    end

    def reset
        @output = ""
    end

    def parse(input)
        return false if input.terminated?

        c = input.get_c

        if @predicate.call(c)
            @output = c.to_s
            input.success(c)
        else
            input.failure(c)
        end
    end
end

