require "../../spec_helper"

describe Haydari::OrParser do
    haydari = get_haydari
    input   = "abcde"

    it "should success if one of the given parsers success" do
        parser = Haydari::OrParser.new(Haydari::StringParser.new("crystal"), Haydari::StringParser.new("ruby"))
        parser.run("crystal").should be_true
        parser.run("ruby").should be_true
    end

    it "should fail if none of the given parsers success" do
        parser = Haydari::OrParser.new(Haydari::StringParser.new("noway"), Haydari::StringParser.new("my bad"))
        parser.run("crystal").should be_false
    end

    it "should be done after first successful parse" do
        parser = Haydari::OrParser.new(Haydari::ReturnParser.new(1), Haydari::ReturnParser.new(2))
        parser.run("").should be_true
        parser.output.should eq 1
    end
end


