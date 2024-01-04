import 'package:bmi_calculator_app/model/health_tip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class HealthTipsViewModel {
  Future<HealthTip?> fetchHealthTip(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, show an alert or handle accordingly
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content: Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null; // Return null to indicate failure due to no internet
    }

    try {
      final response = await http.get(Uri.parse('https://gopalkrushnas063.github.io/bmi_health_tips_api/tips.json'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final healthTip = HealthTip.fromJson(jsonResponse[0]);
        return healthTip;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }
}
