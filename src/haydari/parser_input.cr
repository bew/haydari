struct Haydari::ParserInputState
    property position
    property row
    property col

    def initialize(@position = 0, @row = 0, @col = 0)
    end
end

class Haydari::ParserInput
    getter last
    getter input
    getter state

    @state   = ParserInputState.new
    @markers = [] of ParserInputState

    @last    = '\0'
    @lasts   = [] of Char

    @length  = 0

    def initialize(@input)
        @length = @input.size
    end

    def terminated?
        @state.position == @length
    end

    def get_c
        @input[@state.position]
    end

    def mark
        @markers.unshift @state
        @lasts.unshift @last
    end

    def unmark
        @markers.shift
        @lasts.shift
    end

    def rewind
        @state = @markers.shift? || @state
        @last = @lasts.shift? || @last
    end

    def success
        success(get_c)
    end

    def success(char)
        @state.position += 1
        @state.col      += 1

        if char == '\n'
            @state.col  = 0
            @state.row += 1
        end

        @last = char

        true
    end

    def failure(char)
        false
    end
end
