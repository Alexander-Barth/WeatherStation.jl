using WeatherStation
using Dates

basedir = expanduser("~/.julia/dev/WeatherStation/examples")
parameter = "temperature"
taverage = 1000 * 60 * 10


#=
curl 'http://192.168.1.61:8081/_dash-update-component' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,de;q=0.7,en;q=0.3' --compressed -H 'Referer: http://192.168.1.61:8081/' -H 'Content-Type: application/json' -H 'X-CSRFToken: undefined' -H 'Origin: http://192.168.1.61:8081' -H 'DNT: 1' -H 'Connection: keep-alive' --data-raw '{"output":"graph.figure","changedPropIds":["date-picker-range.end_date"],"inputs":[{"id":"parameter","property":"value","value":"temperature"},{"id":"taverage","property":"value","value":600000},{"id":"date-picker-range","property":"start_date","value":"2020-07-01"},{"id":"date-picker-range","property":"end_date","value":"2020-08-04"}]}'
curl 'http://192.168.1.61:8081/_dash-update-component' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,de;q=0.7,en;q=0.3' --compressed -H 'Referer: http://192.168.1.61:8081/' -H 'Content-Type: application/json' -H 'X-CSRFToken: undefined' -H 'Origin: http://192.168.1.61:8081' -H 'DNT: 1' -H 'Connection: keep-alive' --data-raw '{"output":"graph.figure","changedPropIds":["date-picker-range.end_date"],"inputs":[{"id":"parameter","property":"value","value":"temperature"},{"id":"taverage","property":"value","value":600000},{"id":"date-picker-range","property":"start_date","value":"2020-07-01"},{"id":"date-picker-range","property":"end_date","value":"2020-08-04"}]}'
=#

timerange = (typemin(DateTime),typemax(DateTime))

timerange = (DateTime(2020,07,06),DateTime(2020,07,08))

WeatherStation.loadavg(basedir,parameter,taverage;
	timerange = timerange)
