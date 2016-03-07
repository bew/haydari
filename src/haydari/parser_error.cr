struct Haydari::ParserError
    property state
    property expected
    property received

    def initialize(@state = ParserInputState.new, @expected = "", @received = "")
    end
end

