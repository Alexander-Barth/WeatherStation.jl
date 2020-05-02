
parameters = [
    ("Temperatur","temperature"),
    ("Luftfeuchtigkeit","humidity"),
    ("Windgeschwindigkeit","wind_speed"),
    ("Windrichtung","wind_direction"),
    ("Regenzähler","rain")]

function server(;  basedir = get(ENV,"WEATHERSTATION_DIR","/var/lib/WeatherStation.jl/"),
                port = parse(Int,get(ENV,"WEATHERSTATION_PORT","8081")))


    app = dash("Wetterstation",
               external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"],
#               meta_tags=[
#                   Dict("name" => "viewport",
#                        "content" => "width=device-width, initial-scale=1")
#               ],
               )


    function make_graph_figure(parameter,taverage,timerange = (typemin(DateTime),typemax(DateTime)))
        df = loadavg(basedir,parameter,taverage; timerange = timerange)
        label = Dict([p[2] => p[1] for p in parameters]...)[parameter]

        (
            data = [(
                x = df[:,:time],
                y = df[:,Symbol(parameter)]
            )],
            layout = (title = "$(label) $(taverage/(1000*60)) min",)
        )
    end


    app.layout = html_div() do

        html_h2("Wetterstation"),
        dcc_dropdown(
            id="parameter",
            options=[Dict("label" => p[1], "value" => p[2]) for p in parameters],
            value="temperature"
        ),
        dcc_dropdown(
            id="taverage",
            options=[
                Dict("label" => "1 min", "value" => 1000 * 60 * 1),
                Dict("label" => "10 min", "value" => 1000 * 60 * 10),
                Dict("label" => "1 hour", "value" => 1000 * 60 * 60),
                Dict("label" => "24 hour", "value" => 1000 * 60 * 60 * 24),
            ],
            value=1000 * 60 * 10
        ),
        dcc_datepickerrange(
            id = "date-picker-range",
            min_date_allowed = DateTime(2020, 4, 1),
            #max_date_allowed = Dates.now() + Dates.Day(1),
            start_date = Dates.now() - Dates.Day(7),
            end_date = Dates.now() + Dates.Day(1),
        ),
        dcc_graph(
            id = "graph",
            #figure = make_graph_figure("temperature",1000 * 60 * 10),
            style = Dict("padding-top" => "20px")
        )
    end


    callback!(app, callid"parameter.value,taverage.value,date-picker-range.start_date,date-picker-range.end_date => graph.figure") do value, taverage, t0, t1
        timerange = (DateTime(t0),DateTime(t1))
        @show timerange
        return make_graph_figure(value,taverage,timerange)
    end

    @info("open http://localhost:$port/")
    run_server(app, "0.0.0.0", port)
end
