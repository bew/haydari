require "../parser"

class Haydari::SeparatedByParser(T) < Haydari::Parser(Array(T))
    def initialize(@parser : Parser(T), @separator_parser : Parser(U))
        @output = [] of T
    end

    def reset
        @output = [] of T
        @parser.reset
        @separator_parser.reset
    end

    def output
        @output
    end

    def parse(input)
        input.mark

        separator_parsed = true
        last_parse_failed = false

        while separator_parsed
            if @parser.parse(input)
                input.unmark
                input.mark
                @output << @parser.output.not_nil! as T
                @parser.reset
            else
                last_parse_failed = true
            end

            separator_parsed = @separator_parser.parse(input)
            @separator_parser.reset

            break if last_parse_failed || !separator_parsed
        end

        if !last_parse_failed && !separator_parsed
            true
        elsif @output.size == 0 && !separator_parsed
            true
        else
            @output = [] of T
            false
        end
    end
end
