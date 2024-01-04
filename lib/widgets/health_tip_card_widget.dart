// widgets/health_tip_card_widget.dart
import 'package:bmi_calculator_app/model/health_tip.dart';
import 'package:bmi_calculator_app/viewmodels/health_tips_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class HealthTipCardWidget extends StatefulWidget {
  @override
  _HealthTipCardWidgetState createState() => _HealthTipCardWidgetState();
}

class _HealthTipCardWidgetState extends State<HealthTipCardWidget> {
  final HealthTipsViewModel _viewModel = HealthTipsViewModel();
  late Future<HealthTip?> _healthTip = Future.value(null); // Initialize with null
  bool? _isConnected;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (_isConnected!) {
      _loadHealthTip();
    }
  }

  Future<void> _loadHealthTip() async {
    try {
      final healthTip = await _viewModel.fetchHealthTip(context);
      setState(() {
        _healthTip = Future.value(healthTip);
      });
    } catch (error) {
      // Handle error if any
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (!_isConnected!) {
      return Center(
        child: Text('No internet connection'),
      );
    }

    return FutureBuilder<HealthTip?>(
  future: _healthTip, // Use HealthTip? here
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.data == null) {
      // Handle the case where HealthTip is null (no internet or error)
      return Center(
        child: Text('No health tip available'),
      );
    } else {
      return Card(
        color: const Color(0xFFF2F2F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                snapshot.data!.image,
                height: 210,
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      snapshot.data!.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      snapshot.data!.tips,
                      maxLines: 9,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  },
);

  }
}