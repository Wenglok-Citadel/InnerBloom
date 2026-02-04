import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/features/community/presentation/screens/community_page.dart';
import 'package:inner_bloom_app/features/home/presentation/screens/home_page.dart';
import 'package:inner_bloom_app/features/profile/presentation/screens/profile_page.dart';
import 'package:inner_bloom_app/features/routine/presentation/screens/routine_page.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), CommunityPage(), const RoutinePage(), ProfilePage()];
  }

  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final therapist = Therapist(
  //     name: 'John Cena',
  //     aboutDetails: 'Certified therapist specialising in anxiety.',
  //     rating: 5,
  //     totalReviews: 15,
  //     specialties: ['Anxiety'],
  //   );
  //
  //   unawaited(TherapistService().addTherapist(therapist));
  // }

  void _onTabTapped(int idx) {
    setState(() {
      _currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: brandTeal,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),

          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Routine',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
