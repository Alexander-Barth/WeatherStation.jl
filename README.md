# WeatherStation.jl

Weather Station


* Install rtl_433

https://github.com/merbanan/rtl_433/blob/master/docs/BUILDING.md (or 
https://github.com/merbanan/rtl_433/blob/647ac54b6fe9482da450b8bf2935164c892651ad/docs/BUILDING.md )


Deploy with nginx

In Ubuntu, the commands would be:

```bash
sudo apt-get update
sudo apt-get install nginx
sudo cp ~/.julia/dev/WeatherStation/config/WeatherStation.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/WeatherStation.conf /etc/nginx/sites-enabled/
sudo systemctl reload-or-restart nginx.service 
```

For other Linux distribution these commands should be adapted.

Check for errors:

```bash
sudo systemctl status nginx.service 
```

