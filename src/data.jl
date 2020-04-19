


function load(fname::AbstractString,model,channel)
    @info("fname $fname")

    df = DataFrame(CSV.File(fname, types = Dict(:channel => Int)))
    df.time = DateTime.(df.time,dateformat"yyyy-mm-dd HH:MM:SS")

    dfT = df[(df.model .== model) .& (df.channel .== channel),:]
    @show size(dfT)
    return dfT
end

function load(fnames,model,channel)
    return reduce(vcat,load.(fnames,model,channel))
end


function loadavg(fnames::AbstractVector{<:AbstractString},parameter,taverage;
                 timerange = (typemin(DateTime),typemax(DateTime)))
    if parameter == "temperature"
        model = "Hideki-TS04"
        channel = 2
        param = "temperature_C"
    elseif parameter == "humidity"
        model = "Hideki-TS04"
        channel = 2
        param = "humidity"
    elseif parameter == "wind_speed"
        model = "Hideki-Wind"
        param = "wind_avg_mi_h"
        channel = 4
    elseif parameter == "wind_direction"
        model = "Hideki-Wind"
        param = "wind_dir_deg"
        channel = 4
    elseif parameter == "rain"
        model = "Hideki-Rain"
        param = "rain_mm"
        channel = 4
    end

    dfT = load(fnames,model,channel)
    dfT[!,:time] = Dates.epochms2datetime.(taverage * round.(Int64,Dates.datetime2epochms.(dfT[:,:time]) / taverage));
    df2 = by(dfT,:time; Dict(Symbol(parameter) => (Symbol(param) => mean))...)

    filter!(row -> timerange[1] <= row.time <= timerange[2],df2)

    return df2
end


function loadavg(basedir::AbstractString,parameter,taverage; kwargs...)
    fnames = sort(glob("out-*csv",basedir))
    return loadavg(fnames,parameter,taverage; kwargs...)
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
