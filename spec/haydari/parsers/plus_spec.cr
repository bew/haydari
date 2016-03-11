require "../../spec_helper"

describe Haydari::PlusParser do
    haydari = get_haydari
    input   = "abcde"

    it "should success if both of the given parsers success" do
        parser = Haydari::PlusParser.new(Haydari::ReturnParser.new(1), Haydari::ReturnParser.new(2))
        parser.run("").should be_true

        parser = Haydari::PlusParser.new(Haydari::ReturnParser.new(1), Haydari::CharParser.new('!'))
        parser.run("").should be_false
    end

    it "should collect values for both of the given parsers" do
        parser = Haydari::PlusParser.new(Haydari::ReturnParser.new(1), Haydari::ReturnParser.new(2))
        parser.run("")
        parser.output.should eq [1, 2]
    end
end



