require "../../spec_helper"

describe Haydari::ThenParser do
    haydari = get_haydari
    input   = "1234567890"

    it "should run first parser then second one if first success" do
        seconds_parser_ran = false
        parser = haydari.digit >> haydari.return_(true)

        parser.run(input)
        parser.output.should be_true
    end

    it "should success if both parsers are success" do
        parser1 = haydari.digit >> haydari.digit
        parser1.run(input).should be_true

        parser2 = haydari.digit >> haydari.char('a')
        parser2.run(input).should be_false

        parser3 = haydari.char('a') >> haydari.digit
        parser3.run(input).should be_false
    end

    it "should run parsers left to right when it is nested" do
        left_bracket  = haydari.string("[")
        right_bracket = haydari.string("]")
        commands      = haydari.one_of(",.<>-+").return(1).many

        parser = left_bracket >> commands >> right_bracket
        parser.run("[+-,]").should be_true
        parser.output.should eq "]"
    end
end
