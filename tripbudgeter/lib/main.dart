import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripbudgeter/utils/supabase_config.dart';

import 'package:tripbudgeter/pages/signin_page.dart';
import 'package:tripbudgeter/pages/signup_page.dart';
import 'package:tripbudgeter/pages/home_page.dart';
import 'package:tripbudgeter/pages/trips_page.dart';
import 'package:tripbudgeter/pages/expenses_page.dart';
import 'package:tripbudgeter/pages/more_page.dart';
import 'package:tripbudgeter/pages/add_expense_page.dart';
import 'package:tripbudgeter/pages/add_trip_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hcaqdnseedcrpaootjul.supabase.co',
    anonKey: 'sb_publishable_dd22eyw9CvDUPAcpaFKT_Q_XjrwoNxw',
  );
  runApp(const ProviderScope(child: MyApp()));
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
      initialRoute: '/',
      routes: {
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignupPage(),
        '/trip/add': (context) => const AddTripPage(),
        '/expense/add': (context) => const AddExpensePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Trip Budgeter',
      theme: theme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.data!.session;
        if (session == null) {
          return const SigninPage();
        } else {
          return const MainAppPages();
        }
      },
    );
  }
}

class MainAppPages extends StatefulWidget {
  const MainAppPages({super.key});

  @override
  State<MainAppPages> createState() => _MainAppPagesState();
}

class _MainAppPagesState extends State<MainAppPages>
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

  Widget customNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _tabController.index,
      onDestinationSelected: (int index) {
        _tabController.animateTo(index);
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Home",
        ),
        NavigationDestination(
          icon: const Icon(Icons.pin_drop_outlined),
          selectedIcon: Icon(
            Icons.pin_drop_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Trips",
        ),
        NavigationDestination(
          icon: const Icon(Icons.monetization_on_outlined),
          selectedIcon: Icon(
            Icons.monetization_on,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Expenses",
        ),
        NavigationDestination(
          icon: const Icon(Icons.more_horiz),
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
