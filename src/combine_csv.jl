using Dates
#using PyPlot
using CSV
using DataFrames
using Glob
using Statistics

taverage = 1000 * 60 * 60
taverage = 1000 * 60 * 10

channel = 3
channel = 2
model = "Hideki-Wind"
model = "Hideki-TS04"

function load(fname::AbstractString,model,channel)
    @info("fname $fname")

    df_ = DataFrame(CSV.File(fname, types = Dict(:channel => Int)))
    df = DataFrame(time = DateTime.(df_.time,dateformat"yyyy-mm-dd HH:MM:SS"),
                  model = df_.model,
                  temperature_C = df_.temperature_C,
                  humidity = df_.humidity,
                  channel = df_.channel)

    dropmissing!(df)

    dfT = df[(df.model .== model) .& (df.channel .== channel),:]
    @show size(dfT)
    return dfT
end

function load(fnames,model,channel)
    return reduce(vcat,load.(fnames,model,channel))
end

basedir = get(ENV,"WEATHERSTATION_DIR","/home/abarth/Test/Dash/data/")
filename = joinpath(basedir,"dataframe.csv")

fnames = sort(glob("out-*csv",basedir))

dfT = load(fnames,model,channel)

dfT[!,:time] = Dates.epochms2datetime.(taverage * round.(Int,Dates.datetime2epochms.(dfT[:,:time]) / taverage));

df2 = by(dfT,:time,:temperature_C => mean,:humidity => mean, :temperature_C => std, :humidity => std)


CSV.write(filename, df2)
