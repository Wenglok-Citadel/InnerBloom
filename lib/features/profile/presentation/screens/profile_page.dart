import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/core/repository/firebase_auth_repository.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/screens/sign_in_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      backgroundColor: background,
      // AppBar removed as requested
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + bottomInset),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top header card (no appbar)
                _buildProfileHeader(context),

                const SizedBox(height: 16),

                // stats row
                _buildStatsRow(),

                const SizedBox(height: 18),

                // About card with actions
                _buildAboutCard(context),

                const SizedBox(height: 18),

                _sectionTitle('Recent Mood Potions'),
                const SizedBox(height: 12),
                _moodHistoryList(),

                const SizedBox(height: 18),

                _sectionTitle('Account & Settings'),
                const SizedBox(height: 12),
                _settingsList(context),

                const SizedBox(height: 22),

                // Logout button (full width)
                _logoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // avatar
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.black26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${GetIt.instance<FirebaseAuthRepository>().name ?? ''}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Let’s connect and grow together.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          // edit
          GestureDetector(
            onTap: () => _showEditProfileSheet(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brandTeal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: brandTeal.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    Widget chip({
      required String title,
      required String value,
      Color? valueColor,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? brandTeal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(title: 'Streak', value: '6 🔥'),
        const SizedBox(width: 10),
        chip(title: 'Potions', value: '12', valueColor: Colors.orangeAccent),
        const SizedBox(width: 10),
        chip(title: 'Sessions', value: '8', valueColor: Colors.purple),
      ],
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "A few words about you — your interests, mental health goals, or a short bio. Keep this friendly and light.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditProfileSheet(context),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit profile'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_add_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'My Diary',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  // fixed height horizontal list prevents vertical overflow
  Widget _savedPotionsList() {
    final dummy = List.generate(
      6,
      (i) => {
        'name': i % 2 == 0 ? 'Golden Smile' : 'Calm Rain',
        'colors': i % 2 == 0
            ? [0xFFFFF1D6, 0xFFFFB3A7]
            : [0xFFBFEFD9, 0xFFDDE8FF],
      },
    );

    return SizedBox(
      height: 122, // fixed height to prevent overflow
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dummy.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, index) {
          final item = dummy[index];
          final colors = item['colors'] as List<int>;
          return GestureDetector(
            onTap: () {
              // open potion detail
            },
            child: Container(
              width: 128,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Color(colors[0]), Color(colors[1])],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to view',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _moodHistoryList() {
    final entries = [
      {'title': 'Golden Smile', 'subtitle': 'Happy • 2 days ago'},
      {'title': 'Lavender Whisper', 'subtitle': 'Calm • 3 days ago'},
      {'title': 'Calm Rain Tonic', 'subtitle': 'Reflective • 6 days ago'},
    ];

    return Column(
      children: entries
          .map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ListTile(
                minVerticalPadding: 12,
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF1D6), Color(0xFFFFB3A7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: Colors.white70),
                  ),
                ),
                title: Text(
                  e['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(e['subtitle'] as String),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _settingsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.security, color: Colors.black54),
            title: const Text(
              'Privacy & Security',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Manage data & permissions'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ListTile(
            leading: const Icon(Icons.palette_outlined, color: Colors.black54),
            title: const Text(
              'Appearance',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Theme & font'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: Colors.black54,
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Reminders & sounds'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.black54),
            title: const Text(
              'Help & Feedback',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Report bugs or request features'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout),
        label: const Text('Log out'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.redAccent,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // helper modals
  static void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final TextEditingController nameCtrl = TextEditingController(
          text: GetIt.instance<FirebaseAuthRepository>().name ?? '',
        );
        final TextEditingController bioCtrl = TextEditingController(
          text: 'Let’s connect and grow together.',
        );
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 6,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Edit profile',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Display name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bioCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Short bio'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );
                        },
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandTeal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Are you sure you want to log out of Innerbloom?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignInScreen(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You have been logged out.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
