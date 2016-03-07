require "../spec_helper"

describe Haydari::ParserInput do
    input = Haydari::ParserInput.new("1234567890")

    Spec.before_each do
        input = Haydari::ParserInput.new("1234567890")
    end

    it "increment position for successful reads" do
        5.times { input.success }

        input.get_c.should eq '6'
    end

    it "rewinds back to last marker position" do
        input.success
        input.mark

        input.get_c.should eq '2'

        3.times { input.success }
        input.mark

        input.get_c.should eq '5'

        3.times { input.success }

        input.rewind
        input.get_c.should eq '5'

        input.rewind
        input.get_c.should eq '2'
    end

    it "keeps current position when rewinded but no markers present" do
        input.success
        input.success

        input.rewind

        input.get_c.should eq '3'
    end

    it "marks itself as terminated when reach end of input" do
        10.times { input.success }

        input.terminated?.should be_true
    end
end
