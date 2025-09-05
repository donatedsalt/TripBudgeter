import 'package:flutter/material.dart';

import 'package:tripbudgeter/pages/home_page.dart';
import 'package:tripbudgeter/pages/trips_page.dart';
import 'package:tripbudgeter/pages/expenses_page.dart';
import 'package:tripbudgeter/pages/more_page.dart';

void main() {
  runApp(const MyApp());
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Budgeter',
      theme: theme,
      home: const TripBudgeterHomePage(),
    );
  }
}

class TripBudgeterHomePage extends StatefulWidget {
  const TripBudgeterHomePage({super.key});

  @override
  State<TripBudgeterHomePage> createState() => _TripBudgeterHomePageState();
}

class _TripBudgeterHomePageState extends State<TripBudgeterHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TripsPage(),
    ExpensesPage(),
    MorePage(),
  ];

  final List<PreferredSizeWidget> _appBars = [
    HomePageAppBar(),
    TripsPageAppBar(),
    ExpensesPageAppBar(),
    MorePageAppBar(),
  ];

  final List<Widget> _floatingActionButtons = [
    HomePageFloatingActionButton(),
    TripsPageFloatingActionButton(),
    ExpensesPageFloatingActionButton(),
    MorePageFloatingActionButton(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBars[_currentIndex],
        body: _pages[_currentIndex],
        bottomNavigationBar: customNavigationBar(context),
        floatingActionButton: _floatingActionButtons[_currentIndex],
      ),
    );
  }

  NavigationBar customNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.pin_drop_outlined),
          selectedIcon: Icon(
            Icons.pin_drop_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Trips",
        ),
        NavigationDestination(
          icon: Icon(Icons.monetization_on_outlined),
          selectedIcon: Icon(
            Icons.monetization_on,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Expenses",
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          selectedIcon: Icon(
            Icons.more,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "More",
        ),
      ],
    );
  }
}
