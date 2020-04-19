
Activate on boot

```bash
sudo cp WeatherStation.service /etc/systemd/system/
sudo systemctl start WeatherStation.service
sudo systemctl enable WeatherStation.service


sudo cp WeatherStationServer.service /etc/systemd/system/
sudo systemctl start WeatherStationServer.service
sudo systemctl enable WeatherStationServer.service
```