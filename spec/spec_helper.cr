require "spec"
require "../src/haydari"

class HaydariM
    include Haydari
end

def get_haydari
    HaydariM.new
end
