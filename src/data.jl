function load(fname::AbstractString,model,channel)
    @info("fname $fname")

    df = DataFrame(CSV.File(fname, types = Dict(:channel => Int)))
    df.time = DateTime.(df.time,dateformat"yyyy-mm-dd HH:MM:SS")
#=    df = DataFrame(time = DateTime.(df_.time,dateformat"yyyy-mm-dd HH:MM:SS"),
                  model = df_.model,
                  temperature_C = df_.temperature_C,
                  humidity = df_.humidity,
                  channel = df_.channel)

    dropmissing!(df)
=#
    dfT = df[(df.model .== model) .& (df.channel .== channel),:]
    @show size(dfT)
    return dfT
end

function load(fnames,model,channel)
    return reduce(vcat,load.(fnames,model,channel))
end


function loadavg(fnames::AbstractVector{<:AbstractString},model,channel,taverage)
    dfT = load(fnames,model,channel)
    dfT[!,:time] = Dates.epochms2datetime.(taverage * round.(Int64,Dates.datetime2epochms.(dfT[:,:time]) / taverage));

    df2 = by(dfT,:time,:temperature_C => mean,:humidity => mean, :temperature_C => std, :humidity => std)
    return df2
end

function loadavg(basedir::AbstractString,model,channel,taverage)
    fnames = sort(glob("out-*csv",basedir))
    return loadavg(fnames,model,channel,taverage)
end

function combine(; basedir = get(ENV,"WEATHERSTATION_DIR","/var/lib/WeatherStation.jl/"))

taverage = 1000 * 60 * 60
taverage = 1000 * 60 * 10

channel = 3
channel = 2
model = "Hideki-Wind"
model = "Hideki-TS04"


filename = joinpath(basedir,"dataframe.csv")


dfT = load(fnames,model,channel)


end
