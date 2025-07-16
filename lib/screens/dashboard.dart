// home_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siffrum_sa/widgets/card.dart';

class SuperAdminDashboard extends StatelessWidget {
  SuperAdminDashboard({super.key});

  // Dummy data
  final Map<String, String> _userInfo = {
    'name': 'Admin User',
    'role': 'Super Admin',
    'email': 'admin@company.com',
  };

  final List<Map<String, dynamic>> _stats = [
    {'title': 'Total Users', 'value': '2,458', 'change': '+12%'},
    {'title': 'Active Sessions', 'value': '1,230', 'change': '+3.2%'},
    {'title': 'Revenue', 'value': '\$18,230', 'change': '-1.1%'},
    {'title': 'Pending Tasks', 'value': '18', 'change': '+4'},
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {'user': 'John Doe', 'action': 'Updated settings', 'time': '10 min ago'},
    {'user': 'Jane Smith', 'action': 'Created report', 'time': '25 min ago'},
    {'user': 'Robert Kim', 'action': 'Deleted user', 'time': '1 hour ago'},
    {
      'user': 'Admin User',
      'action': 'Changed permissions',
      'time': '2 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Admin Dashboard'),
        trailing: Icon(CupertinoIcons.bell),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildStatsGrid(context),
                const SizedBox(height: 32),
                _buildRecentActivity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${_userInfo['name']}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _userInfo['role']!,
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 4),
            Text(
              _userInfo['email']!,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final stat = _stats[index];
        return CupertinoCard(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat['title'] as String,
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  stat['value'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      stat['change'].toString().contains('+')
                          ? CupertinoIcons.arrow_up_right
                          : CupertinoIcons.arrow_down_right,
                      size: 14,
                      color: stat['change'].toString().contains('+')
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.systemRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stat['change'] as String,
                      style: TextStyle(
                        color: stat['change'].toString().contains('+')
                            ? CupertinoColors.systemGreen
                            : CupertinoColors.systemRed,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._recentActivities
            .map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['user'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            activity['action'] as String,
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        color: CupertinoColors.systemGrey2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
