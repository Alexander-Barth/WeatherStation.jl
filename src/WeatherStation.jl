module WeatherStation

using CSV
using DataFrames
using Dates
using Dash
using Glob
using Statistics

include("server.jl")
include("data.jl")

end # module
