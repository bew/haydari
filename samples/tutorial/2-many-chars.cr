require "../../src/haydari"

class MyParser
    include Haydari

    defparser space, Array(Char) do
        many char(' ')
    end
end

my_parser = MyParser.new.space
my_parser.run("   ")
puts "'#{my_parser.output}'"

