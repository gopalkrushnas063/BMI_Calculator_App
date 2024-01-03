import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ScoreScreen extends StatefulWidget {
  final double bmiScore;
  final int age;
  String? bmiStatus;
  String? bmiInterpretation;
  Color? bmiStatusColor;

  ScoreScreen({Key? key, required this.bmiScore, required this.age})
      : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    setBmiInterpretation();
    return RepaintBoundary(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Score"),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 12,
            shape: const RoundedRectangleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your Score",
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                PrettyGauge(
                  gaugeSize: 300,
                  minValue: 0,
                  maxValue: 40,
                  segments: [
                    GaugeSegment('UnderWeight', 18.5, Colors.red),
                    GaugeSegment('Normal', 6.4, Colors.green),
                    GaugeSegment('OverWeight', 5, Colors.orange),
                    GaugeSegment('Obese', 10.1, Colors.pink),
                  ],
                  valueWidget: Text(
                    widget.bmiScore.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 40),
                  ),
                  currentValue: widget.bmiScore.toDouble(),
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
                        RenderRepaintBoundary boundary =
                            _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
                        ui.Image image = await boundary.toImage();
                        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

                        if (byteData != null) {
                          Uint8List pngBytes = byteData.buffer.asUint8List();
                          final tempDir = (await getTemporaryDirectory()).path;
                          final file = await new File('$tempDir/screenshot.png').create();
                          await file.writeAsBytes(pngBytes);

                          Share.shareFiles(['$tempDir/screenshot.png'],
                              text: "Your BMI is ${widget.bmiScore.toStringAsFixed(1)} at age ${widget.age}");
                        }
                      },
                      child: const Text("Share"),
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
