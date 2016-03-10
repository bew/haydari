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
end

alias BrainfuckProgramInput = Array(BrainfuckProgram | BrainfuckToken)
class BrainfuckProgram
    IDENTATION = "    "

    getter commands

    def initialize(@commands = [] of BrainfuckToken | self)
    end
end

class BrainfuckParser
    include Haydari

    defparser commands, BrainfuckToken do
        index_of("><+-.,").to_enum BrainfuckToken
    end

    defparser program, BrainfuckProgram do
        sub_programs = string("[") >> program << string("]")

        (commands | sub_programs).many.select do |program|
            BrainfuckProgram.new(program)
        end
    end

    def parse(input : String)
        parser = program
        if parser.run(input)
            parser.output
        else
            raise "Failed"
        end
    end
end
 
bf = BrainfuckParser.new
program = bf.parse("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.")
pp program
