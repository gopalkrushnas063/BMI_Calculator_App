// viewmodels/health_tips_view_model.dart
import 'package:bmi_calculator_app/model/health_tip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthTipsViewModel {
  Future<HealthTip> fetchHealthTip() async {
    final response = await http.get(
        Uri.parse('https://gopalkrushnas063.github.io/bmi_health_tips_api/tips.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final healthTip = HealthTip.fromJson(jsonResponse[0]);
      return healthTip;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
