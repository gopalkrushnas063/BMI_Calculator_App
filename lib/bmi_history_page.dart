import 'package:flutter/material.dart';
import 'package:bmi_calculator_app/helpers/database_helper.dart';
import 'package:bmi_calculator_app/model/bmi_record.dart';

class BMIHistoryPage extends StatefulWidget {
  @override
  _BMIHistoryPageState createState() => _BMIHistoryPageState();
}

class _BMIHistoryPageState extends State<BMIHistoryPage> {
  late DatabaseHelper dbHelper;
  late List<BMIRecord> bmiRecords;

  @override
  void initState() {
    super.initState();
    bmiRecords = [];
    dbHelper = DatabaseHelper();
    fetchBMIRecords();
  }

  void fetchBMIRecords() async {
    List<BMIRecord> records = await dbHelper.getBMIRecords();
    setState(() {
      bmiRecords = records;
    });
  }

  String getStatus(double bmiScore) {
    if (bmiScore >= 0.0 && bmiScore <= 18.4) {
      return 'Underweight';
    } else if (bmiScore >= 18.5 && bmiScore <= 24.9) {
      return 'Normal';
    } else if (bmiScore >= 25.0 && bmiScore <= 29.9) {
      return 'Overweight';
    } else if (bmiScore >= 30.0 && bmiScore <= 34.9) {
      return 'Obese Class I';
    } else if (bmiScore >= 35.0 && bmiScore <= 39.9) {
      return 'Obese Class II';
    } else if (bmiScore >= 40.0) {
      return 'Obese Class III';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI History',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.indigo,
          ),
        ),
        centerTitle: true,
      ),
      body: bmiRecords != null
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: bmiRecords.length,
              itemBuilder: (BuildContext context, int index) {
                Color cardColor = Colors.white; // Default color for the Card

                // Define colors based on BMI score range
                double bmiScore = bmiRecords[index].bmiScore;
                if (bmiScore >= 0.0 && bmiScore <= 18.4) {
                  cardColor = Colors.lightBlue; // Underweight
                } else if (bmiScore >= 18.5 && bmiScore <= 24.9) {
                  cardColor = Colors.green; // Normal
                } else if (bmiScore >= 25.0 && bmiScore <= 29.9) {
                  cardColor = Colors.yellow; // Overweight
                } else if (bmiScore >= 30.0 && bmiScore <= 34.9) {
                  cardColor = Colors.orange; // Obese Class I
                } else if (bmiScore >= 35.0 && bmiScore <= 39.9) {
                  cardColor = Colors.deepOrange; // Obese Class II
                } else if (bmiScore >= 40.0) {
                  cardColor = Colors.deepOrangeAccent; // Obese Class III
                }
                int colorIndex = index % 14;
                List<Color> colors = [
                  Colors.orange,
                  Colors.green,
                  Colors.indigo,
                  Colors.brown,
                  Colors.red,
                  Colors.blue,
                  Colors.redAccent,
                  Colors.lime,
                  Colors.pink,
                  Colors.blueGrey,
                  const Color.fromARGB(255, 58, 162, 13)
                ];
                Color containerColor = colors[colorIndex];

                return Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                width: 1.0,
                                color: cardColor,
                              ),
                            ),
                          ),
                          child: ColorFiltered(
                            colorFilter:
                                ColorFilter.mode(cardColor, BlendMode.srcIn),
                            child: Image.asset(
                              bmiRecords[index].gender == 0
                                  ? "assets/images/female.png"
                                  : "assets/images/male.png",
                              width: 38,
                              height: 38,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error_outline,
                                  color: cardColor,
                                  size: 38,
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          "${getStatus(bmiRecords[index].bmiScore)} | ${bmiRecords[index].bmiScore.toStringAsFixed(1)}",
                          style: TextStyle(
                            color: cardColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(Icons.linear_scale, color: cardColor),
                            Text(
                              "Age: ${bmiRecords[index].age} | Height: ${bmiRecords[index].height} | Weight: ${bmiRecords[index].weight}",
                              style: TextStyle(
                                color: cardColor,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.fast_forward,
                          color: cardColor,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
