import 'package:flutter/material.dart';
import 'package:sky/screens/city_screen.dart';
import 'package:sky/utilites/constants.dart';
import 'package:sky/services/weather.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key, this.locatinWether}) : super(key: key);

  final locatinWether;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temrature = 0;
  String wetherIcon = 'Error';
  String cityname = 'not detected';
  String wetherMassage = 'unable to get';
  WeatherModel wether = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUi(widget.locatinWether);
  }

  void updateUi(dynamic wetherdata) {
    setState(() {
      if (wetherdata == null) {
        temrature = 0;
        wetherIcon = 'Error';
        wetherMassage = 'unable to get wether data';
        cityname = 'not detected';
        return;
      }
      double temp = wetherdata["main"]["temp"];
      temrature = temp.toInt();
      var condition = wetherdata["weather"][0]["id"];
      wetherIcon = wether.getWeatherIcon(condition);
      cityname = wetherdata["name"];
      wetherMassage = wether.getMessage(temrature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var wetherData = await wether.getLocationWether();
                      updateUi(wetherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var wetherData = await wether.getCityWether(typedName);
                        updateUi(wetherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temrature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      wetherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$wetherMassage in $cityname",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
