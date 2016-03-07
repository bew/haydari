require "../../spec_helper"

describe Haydari::ThenParser do
    haydari = get_haydari
    input   = "1234567890"

    it "should run given parser first" do
        digit = haydari.digit
        char  = haydari.char '2'

        then = Haydari::ThenParser.new(digit) do |o| 
            o.should eq '1'
            char
        end

        then.is_a?(Haydari::Parser(Char)).should be_true

        then.run(input).should be_true
        then.output.should eq '2'
    end

    it "should run parsers left to right when it is nested" do
        left_bracket  = haydari.string("[")
        right_bracket = haydari.string("]")
        commands      = haydari.one_of(",.<>-+").many.select { |cmds| cmds.map { 1 } }

        parser2 = haydari.then(left_bracket) do |lb|
            haydari.then(commands) do |cmds|
                haydari.then(right_bracket) do
                    haydari.return cmds
                end
            end
        end

        parser2.run("++--,,..<>").should be_false

        parser2.reset
        parser2.run("[++--,,..<>]").should be_true
        parser2.output.should eq [1] * 10

        parser2 = left_bracket >> commands << right_bracket
        parser2.reset
        parser2.run("---+++,.").should be_false

        parser2.reset
        parser2.run("[++--,,..<>]").should be_true
        parser2.output.should eq [1] * 10
    end
end
