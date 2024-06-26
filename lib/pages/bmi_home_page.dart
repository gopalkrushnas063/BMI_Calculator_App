import 'dart:math';

import 'package:bmi_calculator_app/widgets/age_weight_widget.dart';
import 'package:bmi_calculator_app/widgets/gender_widget.dart';
import 'package:bmi_calculator_app/widgets/height_widget.dart';
import 'package:bmi_calculator_app/pages/score_screen.dart';
import 'package:bmi_calculator_app/widgets/health_tip_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({Key? key}) : super(key: key);

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
   int _gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;



   @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xFFF2F2F2);
    return Scaffold(
      backgroundColor: baseColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Container(
            color: baseColor,
            child: Column(
              children: [
                const SizedBox(height: 70),
                GenderWidget(
                  onChange: (genderVal) {
                    _gender = genderVal;
                  },
                ),
                HeightWidget(
                  onChange: (heightVal) {
                    _height = heightVal;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AgeWeightWidget(
                        onChange: (ageVal) {
                          _age = ageVal;
                        },
                        title: "Age",
                        initValue: 30,
                        min: 0,
                        max: 100),
                    AgeWeightWidget(
                        onChange: (weightVal) {
                          _weight = weightVal;
                        },
                        title: "Weight(Kg)",
                        initValue: 50,
                        min: 0,
                        max: 200)
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: SwipeableButtonView(
                      isFinished: _isFinished,
                      onFinish: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                child: ScoreScreen(
                                  bmiScore: _bmiScore,
                                  age: _age,
                                  gender: _gender,
                                  height: _height,
                                  weight: _weight,
                                ),
                                type: PageTransitionType.fade));
      
                        setState(() {
                          _isFinished = false;
                        });
                      },
                      onWaitingProcess: () {
                        //Calculate BMI here
                        calculateBmi();
      
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      activeColor: Colors.indigo,
                      buttonWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                      buttonText: "CALCULATE"),
                ),
                HealthTipCardWidget(),
              ],
            ),
          ),
        ),
      ),
      
      
    );
  }

  void calculateBmi() {
    _bmiScore = (_weight / pow(_height / 100, 2));
  }
}