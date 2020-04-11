using WeatherStation

basedir = get(ENV,"WEATHERSTATION_DIR","/var/lib/WeatherStation.jl/")
WeatherStation.server(basedir = basedir)
