require "../parser"

class Haydari::StringParser < Haydari::Parser(String)
    def initialize(@string : String)
        @output = ""
        @char_parser = CharParser.new(@string[0])
    end

    def reset
        @output = ""
        @char_parser.reset
    end

    def parse(input)
        input.mark

        successful = true

        @string.each_char do |str_c|
            @char_parser.reset
            @char_parser.char = str_c

            unless @char_parser.parse(input)
                input.rewind
                successful = false
                break
            end
        end

        if successful
            input.unmark

            @output = @string
            true
        else
            false
        end
    end
end

