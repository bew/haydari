require "../parser"

class Haydari::OrParser(T) < Haydari::Parser(T)
    def initialize(@parsers : Array(Parser(T)))
        @output = [] of T
    end

    def reset
        @output = [] of T
        @parsers.each &.reset
    end

    def push_parser(parser : Parser(T))
        @parsers << parser
    end

    def output
        @output[0]
    end

    def parse(input)
        raise Exception.new("No parsers given for or operation") if @parsers.empty?

        @parsers.each do |parser|
            if parser.run(input)
                @output = [parser.output.not_nil!]
                return true
            end
        end

        false
    end
end

