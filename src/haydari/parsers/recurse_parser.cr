require "../parser"

class Haydari::RecurseParser(T) < Haydari::Parser(T)
    def initialize(@generator : ParserGenerator(T))
        @parser = nil
        @output = [] of T
    end

    def reset
        @output = [] of T
    end

    def output
        @output[0]
    end

    def parse(input)
        @parser = @generator.generate
        
        if @parser == nil
            puts "Parser generator returned nil: #{@generator.class.name}"
            return false
        end

        input.mark

        if @parser.try &.parse(input)
            @output << @parser.not_nil!.output.not_nil! as T
            input.unmark
            true
        else
            input.rewind
            false
        end
    end
end
