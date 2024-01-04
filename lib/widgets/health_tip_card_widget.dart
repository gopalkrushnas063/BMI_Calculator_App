// widgets/health_tip_card_widget.dart
import 'package:bmi_calculator_app/model/health_tip.dart';
import 'package:bmi_calculator_app/viewmodels/health_tips_view_model.dart';
import 'package:flutter/material.dart';

class HealthTipCardWidget extends StatefulWidget {
  @override
  _HealthTipCardWidgetState createState() => _HealthTipCardWidgetState();
}

class _HealthTipCardWidgetState extends State<HealthTipCardWidget> {
  final HealthTipsViewModel _viewModel = HealthTipsViewModel();
  late Future<HealthTip> _healthTip;

  @override
  void initState() {
    super.initState();
    _healthTip = _viewModel.fetchHealthTip();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HealthTip>(
      future: _healthTip,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
