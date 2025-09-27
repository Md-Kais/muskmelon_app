import 'package:flutter/material.dart';
import 'package:muskmelon_app/features/recipes/recipe_screen.dart';
import 'package:muskmelon_app/features/remedies/screens/remedies_screen.dart';
import 'package:muskmelon_app/features/support/report_problem_screen.dart';
import 'features/home/home_screen.dart';
import 'features/steps/step_guide_screen.dart';
import 'app_theme.dart';
import 'strings.dart';

final GlobalKey<NavShellState> navShellKey = GlobalKey<NavShellState>();

class NavShell extends StatefulWidget {
  const NavShell({super.key});
  static NavShellState? of(BuildContext context) => navShellKey.currentState;
  @override
  State<NavShell> createState() => NavShellState();
}

class NavShellState extends State<NavShell> {
  int _index = 0;
  void setIndex(int i) => setState(() => _index = i);

  final _pages = const <Widget>[
    HomeScreen(),
    StepGuideScreen(), // ← NEW
    RemediesScreen(),
    RecipeScreen(),
    ReportProblemScreen(),
  ];

  static const _backs = <Color>[
    AppTheme.surface,
    Color(0xFFF6FFF8),
    Color(0xFFFFF8F5),
    Color(0xFFF7FAFF),
    Color(0xFFFFFBF0),
  ];

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: _backs[_index],
        child: _pages[_index],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 3,
        indicatorColor: AppTheme.primary.withValues(alpha: .18),
        selectedIndex: _index,
        onDestinationSelected: setIndex,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t.tabHome),
          NavigationDestination(
              icon: const Icon(Icons.format_list_bulleted_outlined),
              selectedIcon: const Icon(Icons.format_list_bulleted),
              label: t.tabSteps),
          NavigationDestination(
              icon: const Icon(Icons.bug_report_outlined),
              selectedIcon: const Icon(Icons.bug_report),
              label: t.tabPests),
          NavigationDestination(
              icon: const Icon(Icons.restaurant_menu_outlined),
              selectedIcon: const Icon(Icons.restaurant_menu),
              label: t.tabRecipes),
          NavigationDestination(
              icon: const Icon(Icons.support_agent_outlined),
              selectedIcon: const Icon(Icons.support_agent),
              label: t.tabSupport),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text('$title — আসছে শীঘ্রই',
            style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
