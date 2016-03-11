require "../../spec_helper"

describe Haydari::RecurseParser do
    it "should create a parser from given parser generator on parse" do
        generator = AllwaysSuccess.new

        parser = Haydari::RecurseParser.new(generator)
        parser.run("")
        generator.generate_count.should eq 1
    end

    it "should success if the generated parser success" do
        parser = Haydari::RecurseParser.new(AllwaysSuccess.new)
        parser.run("a").should be_true

        parser = Haydari::RecurseParser.new(AllwaysFail.new)
        parser.run("a").should be_false
    end
end

class AllwaysSuccess < Haydari::ParserGenerator(Int32)
    getter generate_count : Int32
    def initialize()
        @generate_count = 0
    end

    def generate
        @generate_count += 1
        Haydari::ReturnParser.new(1)
    end
end

class AllwaysFail < Haydari::ParserGenerator(Char)
    def generate
        Haydari::CharParser.new('\0')
    end
end
