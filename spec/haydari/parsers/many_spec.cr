require "../../spec_helper"

describe Haydari::ManyParser do
    haydari = get_haydari
    input   = "abcde"

    it "should always success if at least parameter is 0" do
        parser = Haydari::ManyParser.new haydari.digit

        parser.run(input).should be_true
        parser.output.should eq [] of Char
    end

    it "should raise an error if the given parser is also many" do
        expect_raises do
            many = Haydari::ManyParser.new(Haydari::CharParser.new('1'))
            wrapper = Haydari::ManyParser.new(many)
        end
    end
end

