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
      home: const TripBudgeterApp(),
    );
  }
}

class TripBudgeterApp extends StatefulWidget {
  const TripBudgeterApp({super.key});

  @override
  State<TripBudgeterApp> createState() => _TripBudgeterAppState();
}

class _TripBudgeterAppState extends State<TripBudgeterApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Widget> _pages = const [
    HomePage(),
    TripsPage(),
    ExpensesPage(),
    MorePage(),
  ];

  final List<PreferredSizeWidget> _appBars = const [
    HomePageAppBar(),
    TripsPageAppBar(),
    ExpensesPageAppBar(),
    MorePageAppBar(),
  ];

  final List<Widget> _floatingActionButtons = const [
    HomePageFloatingActionButton(),
    TripsPageFloatingActionButton(),
    ExpensesPageFloatingActionButton(),
    MorePageFloatingActionButton(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBars[_tabController.index],
        body: TabBarView(controller: _tabController, children: _pages),
        bottomNavigationBar: customNavigationBar(context),
        floatingActionButton: _floatingActionButtons[_tabController.index],
      ),
    );
  }

  NavigationBar customNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _tabController.index,
      onDestinationSelected: (int index) {
        _tabController.animateTo(index);
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
