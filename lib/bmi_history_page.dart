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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI History'),
      ),
      body: Center(
        child: bmiRecords != null
            ? ListView.builder(
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

                  return Card(
                    color: cardColor,
                    child: ListTile(
                      title: Text(
                        'Record ID: ${bmiRecords[index].id}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'BMI Score: ${bmiRecords[index].bmiScore.toStringAsFixed(1)}, Age: ${bmiRecords[index].age}, Gender: ${bmiRecords[index].gender}, Height: ${bmiRecords[index].height}, Weight: ${bmiRecords[index].weight}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
