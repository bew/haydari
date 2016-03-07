require "../parser"

class Haydari::ReturnParser(T) < Haydari::Parser(T)
    def initialize(@input : T)
        @output = @input
    end

    def reset
        @output = @input
    end

    def parse(input)
        @output = @input
        true
    end
end

