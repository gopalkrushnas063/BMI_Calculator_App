import 'dart:async';

import 'package:bmi_calculator_app/bmi_category_list.dart';
import 'package:bmi_calculator_app/bmi_history_page.dart';
import 'package:bmi_calculator_app/helpers/database_helper.dart';
import 'package:bmi_calculator_app/info_grid.dart';
import 'package:bmi_calculator_app/model/bmi_record.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ScoreScreen extends StatefulWidget {
  final double bmiScore;
  final int age;
  final int gender;
  final int height;
  final int weight;
  String? bmiStatus;
  String? bmiInterpretation;
  Color? bmiStatusColor;

  ScoreScreen({
    Key? key,
    required this.bmiScore,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _needleAnimation;
  late Animation<double> _scoreAnimation;
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    // Inserting a BMI record into the database
    insertBMIRecord();

    // Fetching all BMI records after inserting
    fetchAllBMIRecords();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration
    );

    _needleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.bmiScore,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.bmiScore,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward(); // Start the animations
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void insertBMIRecord() async {
    BMIRecord record = BMIRecord(
      bmiScore: widget.bmiScore,
      age: widget.age,
      gender: widget.gender,
      height: widget.height,
      weight: widget.weight,
    );
    await dbHelper.insertBMIRecord(record);

    // Wait for a short duration before fetching records
    await Future.delayed(
        Duration(milliseconds: 500)); // Adjust the delay time as needed

    // Fetch records after insertion completes
    fetchAllBMIRecords();
  }

  void fetchAllBMIRecords() async {
    List<BMIRecord> records = await dbHelper.getBMIRecords();
    for (var record in records) {
      print(
          "BMI Record - ID: ${record.id}, Score: ${record.bmiScore}, Age: ${record.age}, Gender: ${record.gender}, Height: ${record.height}, Weight: ${record.weight}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xFFF2F2F2);
    setBmiInterpretation();
    return RepaintBoundary(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          centerTitle: true,
          title: const Text("BMI Score"),
        ),
        body: Container(
          color: baseColor,
          padding: const EdgeInsets.all(12),
          child: ClayContainer(
            borderRadius: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    height: 180,
                    child: MyGridView(
                      age: widget.age,
                      height: widget.height,
                      weight: widget.weight,
                      gender: widget.gender,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                PrettyGauge(
                  gaugeSize: 200,
                  minValue: 0,
                  maxValue: 40,
                  segments: [
                    GaugeSegment('UnderWeight', 18.5, Colors.red),
                    GaugeSegment('Normal', 6.4, Colors.green),
                    GaugeSegment('OverWeight', 5, Colors.orange),
                    GaugeSegment('Obese', 10.1, Colors.pink),
                  ],
                  valueWidget: Text(
                    _needleAnimation.value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 40),
                  ),
                  currentValue: _needleAnimation.value,
                  needleColor: Colors.blue,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.bmiStatus!,
                  style: TextStyle(fontSize: 20, color: widget.bmiStatusColor!),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.bmiInterpretation!,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                BMICategoryList(bmiScore: widget.bmiScore),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Re-calculate"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        RenderRepaintBoundary boundary = _key.currentContext!
                            .findRenderObject() as RenderRepaintBoundary;
                        ui.Image image = await boundary.toImage();
                        ByteData? byteData = await image.toByteData(
                            format: ui.ImageByteFormat.png);

                        if (byteData != null) {
                          Uint8List pngBytes = byteData.buffer.asUint8List();
                          final tempDir = (await getTemporaryDirectory()).path;
                          final file = await new File('$tempDir/screenshot.png')
                              .create();
                          await file.writeAsBytes(pngBytes);

                          Share.shareFiles(['$tempDir/screenshot.png'],
                              text:
                                  "Your BMI is ${widget.bmiScore.toStringAsFixed(1)} at age ${widget.age}");
                        }
                      },
                      child: const Text("Share"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BMIHistoryPage()),
                        );
                      },
                      child: Text('View BMI History'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setBmiInterpretation() {
    if (widget.bmiScore > 30) {
      widget.bmiStatus = "Obese";
      widget.bmiInterpretation = "Please work to reduce obesity";
      widget.bmiStatusColor = Colors.pink;
    } else if (widget.bmiScore >= 25) {
      widget.bmiStatus = "Overweight";
      widget.bmiInterpretation = "Do regular exercise & reduce the weight";
      widget.bmiStatusColor = Colors.orange;
    } else if (widget.bmiScore >= 18.5) {
      widget.bmiStatus = "Normal";
      widget.bmiInterpretation = "Enjoy, You are fit";
      widget.bmiStatusColor = Colors.green;
    } else if (widget.bmiScore < 18.5) {
      widget.bmiStatus = "Underweight";
      widget.bmiInterpretation = "Try to increase the weight";
      widget.bmiStatusColor = Colors.red;
    }
  }
}
