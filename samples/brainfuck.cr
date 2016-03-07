require "../src/haydari"

enum BrainfuckToken
    BlockStart
    BlockEnd
    Next
    Previous
    Inc
    Dec
    Output
    Store

    def self.from_string(str : String)
        case str
        when "["
            BlockStart
        when "]"
            BlockEnd
        when ">"
            Next
        when "<"
            Previous
        when "+"
            Inc
        when "-"
            Dec
        when "."
            Output
        when ","
            Store
        else
            BlockStart
        end
    end

    def self.to_string(token : BrainfuckToken)
        case token
        when Next
            ">"
        when Previous
            "<"
        when Inc
            "+"
        when Dec
            "-"
        when Output
            "."
        when Store
            ","
        else
            ">"
        end
    end
end

class BrainfuckProgram
    def initialize(@commands = [] of BrainfuckToken | self)
    end

    def pretty_print(identation = 0)
        puts " " * identation + "["
        @commands.each do |c|
            if c.is_a?(BrainfuckProgram)
                c.pretty_print(identation + 1)
            else
                puts (" " * identation) + "    " + BrainfuckToken.to_string c
            end
        end
        puts " " * identation + "]"
    end
end

class BrainfuckParser
    include Haydari

    def parse_command
        parser = one_of("><+-.,")
        return parser.select { |t| BrainfuckToken.from_string(t.to_s) }
    end

    # Since Proc's return type is NoReturn for recursives recursion 
    # is disabled for now
    def parse_program
        start_t      = string("[").maybe
        commands   = parse_command.many
        end_t        = string("]").maybe

        (start_t >> commands << end_t).select { |cmds| BrainfuckProgram.new cmds }
    end

    def parse(input : String)
        parser = parse_program

        if parser.run(input)
            parser.output
        end
    end
end

bf = BrainfuckParser.new
program = bf.parse("[--++,.,.<-+.,]") # doesn't mean anything
(program as BrainfuckProgram).try &.pretty_print

