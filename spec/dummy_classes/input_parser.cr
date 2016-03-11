require "../../src/haydari/parser_input"

class DummyParserInput
    getter get_c_count : Int32
    getter success_count : Int32
    getter fail_count : Int32
    getter mark_count : Int32
    getter rewind_count : Int32
    getter unmark_count : Int32
    getter terminated_count : Int32
    
    def initialize (@string : String)
        @parser_input = Haydari::ParserInput.new(@string)

        @get_c_count = 0
        @success_count = 0
        @fail_count = 0
        @mark_count = 0
        @unmark_count = 0
        @rewind_count = 0
        @terminated_count = 0
    end

    def get_c
        @get_c_count += 1
        @parser_input.get_c
    end
    
    def success(c : Char)
        @success_count += 1
        @parser_input.success(c)
    end

    def failure(c : Char)
        @fail_count += 1
        @parser_input.failure(c)
    end

    def mark
        @mark_count += 1
        @parser_input.mark
    end

    def unmark
        @unmark_count += 1
        @parser_input.unmark
    end

    def rewind
        @rewind_count += 1
        @parser_input.rewind
    end

    def terminated?
        @terminated_count += 1
        @parser_input.terminated?
    end
end
