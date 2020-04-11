using Dash
using CSV
using DataFrames


basedir = get(ENV,"WEATHERSTATION_DIR","/home/abarth/Test/Dash/data/")
filename = joinpath(basedir,"dataframe.csv")

df = DataFrame(CSV.File(filename))

app = dash("Test app", external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])


function make_graph_figure(coeff)
   x_range = -10.0:0.1:10
   (
       data = [(
           x = df[:,:time],
           y = df[:,Symbol(coeff)]
       )],
       layout = (title = "$(coeff)",)
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
    dcc_graph(
        id="graph",
        figure = make_graph_figure("temperature_C_mean"),
        style = Dict("padding-top" => "20px")
    )
end


callback!(app, callid"demo-dropdown.value => graph.figure") do value
    return make_graph_figure(value)
end

@info("open http://localhost:8081/")
run_server(app, "0.0.0.0", 8081)
