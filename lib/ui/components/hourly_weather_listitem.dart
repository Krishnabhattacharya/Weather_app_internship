import 'package:flutter/material.dart';
import 'package:internship_weather_app/model/weather_model.dart';
import 'package:intl/intl.dart';

class HourlyWeatherListItem extends StatelessWidget {
  final Hour? hour;

  const HourlyWeatherListItem({Key? key, this.hour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      width: w * 0.27,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(hour?.tempC?.round().toString() ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Text("o", style: TextStyle(color: Colors.white)),
            ],
          ),
          Container(
            height: 50,
            child: Image.network("https:${hour?.condition?.icon.toString()}"),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
          ),
          Text(
              DateFormat.j()
                  .format(DateTime.parse(hour?.time?.toString() ?? "")),
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
