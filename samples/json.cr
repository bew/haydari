require "../src/haydari"

class JSONParser
    include Haydari

    alias JValue   = String | Int32 | Bool | Nil | Array(JValue) | Hash(String, JValue)
    alias KeyValue = {String, JValue}

    defparser string_lit, String do
        string("\"") >> none_of("\"\n").many.text << string("\"")
    end

    defparser bool_lit, Bool do
        string("true").return(true) | string("false").return(false)
    end

    defparser contents, JValue do
        string_lit | array_lit | object_lit | bool_lit | number
    end

    defparser comma, String do
        ws.many >> string(",") << ws.many
    end

    defparser array_lit, Array(JValue) do
        string("[") >> ws.many >> contents.sep(comma) << ws.many << string("]")
    end

    defparser key_value, KeyValue do
        string_lit.then { |key|
            ws.many >> string(":") >> ws.many >> contents.select { |value|
                {key, value}
            }
        }
    end

    defparser object_lit, Hash(String, JValue) do
        string("{") >> ws.many >> key_value.sep(comma).select { |kvs|
            hash = Hash(String, JValue).new
            kvs.each do |kv|
                hash[kv[0]] = kv[1]
            end
            hash
        } << ws.many << string("}")
    end

    def run(input)
        puts typeof(object_lit)
        parser = object_lit
        if parser.run(input)
            parser.output
        else
            raise "Failed!"
        end
    end
end

json_parser = JSONParser.new
hash = json_parser.run("{\"hello\" : \"world\", \"arr\":\n [1, 2, 3, true, {\"sub\"   : \"gell\"}]}")
puts hash.inspect
