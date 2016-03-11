require "../../spec_helper"

describe Haydari::SatisfyParserString do
    it "shuold immediately fails if given input terminated" do
        success = Haydari::SatisfyParserString.new { |c| true }
        success.run("").should be_false
    end

    it "should success if the given predicate function returns true" do
        success = Haydari::SatisfyParserString.new { |c| true }
        fail = Haydari::SatisfyParserString.new { |c| false }

        success.run(" ").should be_true
        success.output.should eq " "
        
        fail.run(" ").should be_false
    end
end

