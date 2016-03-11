require "../../spec_helper"

describe Haydari::ManyParser do
    haydari = get_haydari
    input   = "abcde"

    it "should always success if at least parameter is 0" do
        parser = Haydari::ManyParser.new haydari.digit

        parser.run(input).should be_true
        parser.output.should eq [] of Char
    end
end

