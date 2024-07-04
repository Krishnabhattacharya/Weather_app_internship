import 'package:flutter/material.dart';
import 'package:internship_weather_app/service/provider_service.dart';
import 'package:provider/provider.dart';
import 'package:internship_weather_app/model/weather_model.dart';

import 'components/future_forcast_listitem.dart';
import 'components/hourly_weather_listitem.dart';
import 'components/todays_weather.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final _textFieldController = TextEditingController();

    void _showTextInputDialog(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Search Location'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "search by city,zip"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if (_textFieldController.text.isNotEmpty) {
                    provider.queryText = _textFieldController.text;
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Flutter Weather App"),
        actions: [
          IconButton(
            onPressed: () => _showTextInputDialog(context),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => provider.setQueryToAutoIP(),
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, _) {
            return FutureBuilder(
              future: weatherProvider.getWeatherData(weatherProvider.queryText),
              builder: (context, AsyncSnapshot<WeatherModel?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                WeatherModel? weatherModel = snapshot.data;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TodaysWeather(weatherModel: weatherModel),
                      const SizedBox(height: 10),
                      const Text(
                        "Weather By Hours",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            Hour? hour = weatherModel
                                ?.forecast?.forecastday?[0].hour?[index];
                            return HourlyWeatherListItem(hour: hour);
                          },
                          itemCount: weatherModel
                                  ?.forecast?.forecastday?[0].hour?.length ??
                              0,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Next 7 Days Weather",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 450,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return FutureForcastListItem(
                              forecastday:
                                  weatherModel?.forecast?.forecastday?[index],
                            );
                          },
                          itemCount:
                              weatherModel?.forecast?.forecastday?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
