import 'package:bmi_calculator_app/pages/bmi_history_page.dart';
import 'package:bmi_calculator_app/pages/bmi_home_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BMIHomePage(),
    BMIHistoryPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.indigo,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.assignment, title: 'BMI History'),
        ],
        onTap: (int index) {
          // Implement your logic here based on the tapped index
          setState(() {
            _currentIndex =
                index; // Assuming _currentIndex is a variable in your State
          });

          // You can add additional logic here based on the tapped index
          switch (index) {
            case 0:
              // Logic for Home tab
              break;
            case 1:
              // Logic for Discovery tab
              break;
            case 2:
              // Logic for Add tab
              break;
            // Add more cases for additional tabs if needed
          }
        },
        initialActiveIndex: _currentIndex, // Set initial active index
      ),
    );
  }
}
