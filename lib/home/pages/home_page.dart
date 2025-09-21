import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nourishpal/core/widgets/common.dart';
import 'package:nourishpal/main.dart';
import 'package:nourishpal/services/food_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final repo = foodRepo; // simple global for demo

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome,',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            IconBadgeCard(
              icon: Icons.access_time,
              background: const Color(0xFFF6D9B8),
              title: 'Upcoming Expiries',
              subtitle:
                  '${repo.expiringTomorrowCount()} item(s) expiring tomorrow',
              onTap: () {},
            ),
            IconBadgeCard(
              icon: Icons.add,
              background: const Color(0xFFDDEDD9),
              title: 'Quick Add Food',
              onTap: () => context.push('/add'),
            ),
            // const IconBadgeCard(
            //   icon: Icons.lightbulb_outline,
            //   background: Color(0xFFFBE3C9),
            //   title: 'Meal Suggestions',
            //   subtitle: 'Ideas based on what you have',
            // ),
            const SizedBox(height: 12),
            Text(
              'Your Items',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...repo.items.map(
              (e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: const Icon(Icons.restaurant),
                title: Text(e.name),
                subtitle: Text(
                  '${e.quantity} · Expires ${FoodRepository.fmt(e.expiry)}',
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: index,
      //   onDestinationSelected: (i) => setState(() => index = i),
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.home_outlined),
      //       selectedIcon: Icon(Icons.home),
      //       label: '',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.add_circle_outline),
      //       selectedIcon: Icon(Icons.add_circle),
      //       label: '',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.notifications_none),
      //       selectedIcon: Icon(Icons.notifications),
      //       label: '',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.person_outline),
      //       selectedIcon: Icon(Icons.person),
      //       label: '',
      //     ),
      //   ],
      // ),
    );
  }
}
