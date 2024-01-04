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
                  return ListTile(
                    title: Text(
                      'Record ID: ${bmiRecords[index].id}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      'BMI Score: ${bmiRecords[index].bmiScore.toStringAsFixed(1)}, Age: ${bmiRecords[index].age}, Gender: ${bmiRecords[index].gender}, Height: ${bmiRecords[index].height}, Weight: ${bmiRecords[index].weight}',
                    ),
                  );
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
