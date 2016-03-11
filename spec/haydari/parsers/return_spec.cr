require "../../spec_helper"

describe Haydari::ReturnParser do
    it "should allways success" do
        parser = Haydari::ReturnParser.new(true)
        parser.run("").should be_true
        parser.run("-").should be_true
    end

    it "should allways output given value" do
        parser = Haydari::ReturnParser.new(true)
        parser.run("")
        parser.output.should be_true

        parser = Haydari::ReturnParser.new(['a'])
        parser.run("")
        parser.output.should eq ['a']
    end
end
