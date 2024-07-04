import 'package:flutter/material.dart';
import 'package:internship_weather_app/model/weather_model.dart';
import 'package:internship_weather_app/service/api_service.dart';

class WeatherProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  String _queryText = "auto:ip";

  String get queryText => _queryText;

  set queryText(String text) {
    _queryText = text;
    notifyListeners();
  }

  void setQueryToAutoIP() {
    _queryText = "auto:ip";
    notifyListeners();
  }

  Future<WeatherModel?> getWeatherData(String query) async {
    try {
      return await apiService.getWeatherData(query);
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }
}
