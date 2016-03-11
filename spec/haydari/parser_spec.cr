require "../spec_helper"

describe Haydari::Parser do
    h = get_haydari

    it ">> parser" do
        parser = h.string("hello") >> h.string(" ") >> h.string("world")
        parser.run("hello world").should be_true
        parser.output.should eq "world"
    end

    it ">> \"string\"" do
        parser = h.string("hello") >> " " >> "world"
        parser.run("hello world").should be_true
        parser.output.should eq "world"
    end

    it "<< parser" do
        parser = h.string("hello") >> h.return_(1) << h.string("world")
        parser.run("helloworld").should be_true
        parser.output.should eq 1
    end

    it "<< \"string\"" do
        parser = h.spaces >> h.return_(1) << "crystal"
        parser.run(" crystal").should be_true
        parser.output.should eq 1
    end
end
