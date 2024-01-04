import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bmi_calculator_app/bmi_history_page.dart';
import 'package:bmi_calculator_app/bmi_home_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
            _controller.index = index; // Update the controller index
          });
        },
        children: [
          const BMIHomePage(), // Removed 'const'
          BMIHistoryPage(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: false,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.black87,
        removeMargins: false,
        bottomBarWidth: MediaQuery.of(context).size.width,
        durationInMilliSeconds: 300,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_filled,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.home_filled,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.history,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.history,
              color: Colors.blueAccent,
            ),
            itemLabel: 'History',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
