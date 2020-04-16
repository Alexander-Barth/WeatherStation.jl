
function server(;  basedir = get(ENV,"WEATHERSTATION_DIR","/var/lib/WeatherStation.jl/"),
                port = parse(Int,get(ENV,"WEATHERSTATION_PORT","8081")))


    app = dash("WeatherStation", external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])


    function make_graph_figure(parameter,taverage)
        #taverage = 1000 * 60 * 10

        channel = 2
        model = "Hideki-TS04"

        df = loadavg(basedir,model,channel,taverage)

        (
            data = [(
                x = df[:,:time],
                y = df[:,Symbol(parameter)]
            )],
            layout = (title = "$(parameter) $(taverage/(1000*60)) min",)
        )
    end


    app.layout = html_div() do

        html_h1("Wetterstation"),
        dcc_dropdown(
            id="demo-dropdown",
            options=[
                Dict("label" => "Temperatur", "value" => "temperature_C_mean"),
                Dict("label" => "Luftfeuchtigkeit", "value" => "humidity_mean"),
            ],
            value="temperature_C_mean"
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
        dcc_graph(
            id="graph",
            figure = make_graph_figure("temperature_C_mean",1000 * 60 * 10),
            style = Dict("padding-top" => "20px")
        )
    end


    callback!(app, callid"demo-dropdown.value,taverage.value => graph.figure") do value, taverage
        return make_graph_figure(value,taverage)
    end

    @info("open http://localhost:$port/")
    run_server(app, "0.0.0.0", port)
end
