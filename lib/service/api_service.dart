import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:internship_weather_app/constants/constants.dart';
import 'package:internship_weather_app/model/weather_model.dart';

class ApiService {
  Future<WeatherModel> getWeatherData(String searchText) async {
    String url = "$base_url&q=$searchText&days=7";

    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);

        WeatherModel weatherModel = WeatherModel.fromJson(json);
        log("hi");

        return weatherModel;
      } else {
        throw Exception("No data found");
      }
    } catch (e) {
      log("Failed to load weather data: $e");
      throw Exception("Failed to load weather data: $e");
    }
  }
}
