require "../../spec_helper"

describe Haydari::NotParser do
    haydari = get_haydari
    input   = "abcde"

    it "should success if given char parser fails" do
        parser = Haydari::NotParser(Char).new(Haydari::CharParser.new('!'))
        parser.run("a").should be_true
        parser.run("!").should be_false
    end
end

