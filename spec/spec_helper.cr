require "spec"
require "../src/haydari"
require "./dummy_classes/*"

class HaydariM
    include Haydari
end

def get_haydari
    HaydariM.new
end
