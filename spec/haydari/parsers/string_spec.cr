require "../../spec_helper"

describe Haydari::StringParser do
    it "should success when it parse given string" do
        success = Haydari::StringParser.new("crystal")
        success.run("crystal").should be_true

        success = Haydari::StringParser.new("crystal")
        success.run("crysta").should be_false
    end

    it "should output given string" do
        success = Haydari::StringParser.new("crystal")
        success.run("crystal")
        success.output.should eq "crystal"
    end
end


