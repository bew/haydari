require "../../spec_helper"

describe Haydari::CharParser do
    haydari = get_haydari
    input   = "abcde"

    it "should parse given character from input" do
        parser = haydari.char('!')
        parser.run("!").should be_true
        parser.output.should eq '!'
    end

    it "should notify parser_input after success and fails" do
        parser_input = DummyParserInput.new(" 1a")
        parser = haydari.char(' ')
        parser.parse(parser_input)

        parser_input.terminated_count.should eq 1
        parser_input.get_c_count.should eq 1
        parser_input.success_count.should eq 1
    end

    it "should safely fail if input terminated" do
        parser_input = DummyParserInput.new("")
        parser = haydari.char(' ')
        parser.parse(parser_input).should eq false

        parser_input.terminated_count.should eq 1
        parser_input.get_c_count.should eq 0
        parser_input.success_count.should eq 0
    end
end
