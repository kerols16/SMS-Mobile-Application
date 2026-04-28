import 'package:flutter/material.dart';
import '../../../core/widgets/bottom_nav.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _activeTab = 'dashboard';

  final List<NavItem> _navItems = [
    NavItem(id: 'dashboard', label: 'Dashboard', icon: Icons.home),
    NavItem(id: 'academics', label: 'Academics', icon: Icons.menu_book),
    NavItem(id: 'operations', label: 'Operations', icon: Icons.settings),
    NavItem(id: 'messages', label: 'Messages', icon: Icons.message),
    NavItem(id: 'profile', label: 'Profile', icon: Icons.people),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Good Morning',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Admin Dashboard',
                            style: TextStyle(
                              color: Color(0xFFBFDBFE),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Dashboard Tab
              if (_activeTab == 'dashboard')
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // Stats Cards
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStatCard(
                            icon: Icons.people,
                            color: Colors.blue,
                            value: '1,248',
                            label: 'Active Students',
                            trend: Icons.trending_up,
                          ),
                          _buildStatCard(
                            icon: Icons.check_circle,
                            color: Colors.green,
                            value: '1,173',
                            label: 'Today\'s Attendance',
                            badge: '94%',
                          ),
                          _buildStatCard(
                            icon: Icons.attach_money,
                            color: Colors.orange,
                            value: '\$45.2K',
                            label: 'Pending Fees',
                            alert: Icons.warning,
                          ),
                          _buildStatCard(
                            icon: Icons.people,
                            color: Colors.purple,
                            value: '52',
                            label: 'Staff Present',
                            badge: '56',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildActionButton(
                                  icon: Icons.person_add,
                                  label: 'Add Student',
                                  color: Colors.blue,
                                ),
                                _buildActionButton(
                                  icon: Icons.campaign,
                                  label: 'Announcement',
                                  color: Colors.green,
                                ),
                                _buildActionButton(
                                  icon: Icons.description,
                                  label: 'Generate Report',
                                  color: Colors.purple,
                                ),
                                _buildActionButton(
                                  icon: Icons.calendar_today,
                                  label: 'Schedule Meeting',
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Today's Alerts
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Today\'s Alerts',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildAlertItem(
                              icon: Icons.warning,
                              color: Colors.red,
                              title: '3 students with low attendance',
                              subtitle: 'Below 75% threshold',
                            ),
                            const SizedBox(height: 8),
                            _buildAlertItem(
                              icon: Icons.attach_money,
                              color: Colors.orange,
                              title: '24 pending fee payments',
                              subtitle: 'Due this week',
                            ),
                            const SizedBox(height: 8),
                            _buildAlertItem(
                              icon: Icons.calendar_today,
                              color: Colors.blue,
                              title: 'Parent-teacher meeting tomorrow',
                              subtitle: 'Grade 10 - 2:00 PM',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recent Activity
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildActivityItem(
                              icon: Icons.person_add,
                              color: Colors.green,
                              title: 'New student registration',
                              subtitle: 'Sarah Johnson - Grade 9A',
                              time: '2 hours ago',
                            ),
                            const SizedBox(height: 12),
                            _buildActivityItem(
                              icon: Icons.check_circle,
                              color: Colors.blue,
                              title: 'Leave request approved',
                              subtitle: 'Mr. Thompson - 2 days',
                              time: '4 hours ago',
                            ),
                            const SizedBox(height: 12),
                            _buildActivityItem(
                              icon: Icons.description,
                              color: Colors.purple,
                              title: 'Monthly report generated',
                              subtitle: 'January 2026 - All departments',
                              time: '1 day ago',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),

              // Academics Tab
              if (_activeTab == 'academics')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Academics Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Class List
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Classes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...['Grade 9A', 'Grade 9B', 'Grade 10A', 'Grade 10B'].map((grade) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.people,
                                                color: Colors.blue.shade600,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    grade,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF374151),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  const Text(
                                                    '32 students',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Attendance Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attendance Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildAttendanceRow('Grade 9', 96, '61/64'),
                            const SizedBox(height: 12),
                            _buildAttendanceRow('Grade 10', 92, '59/64'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Exam Schedule
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upcoming Exams',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildExamItem(
                              subject: 'Mathematics Final',
                              grade: 'Grade 10',
                              date: 'Feb 15',
                              color: Colors.purple,
                            ),
                            const SizedBox(height: 12),
                            _buildExamItem(
                              subject: 'Science Practical',
                              grade: 'Grade 9',
                              date: 'Feb 18',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

              // Operations Tab
              if (_activeTab == 'operations')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Operations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Fee Collection
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Fee Collection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Icon(Icons.attach_money, color: Colors.green, size: 24),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildFeeRow('Today\'s Collection', '\$12,450', Colors.green),
                            const SizedBox(height: 12),
                            _buildFeeRow('Pending This Week', '\$45,200', Colors.orange),
                            const SizedBox(height: 12),
                            _buildFeeRow('Total Overdue', '\$8,900', Colors.red),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Staff Management
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Staff Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildStaffStatusItem(
                              icon: Icons.check_circle,
                              color: Colors.green,
                              title: 'Present Today',
                              subtitle: '52 out of 56 staff',
                            ),
                            const SizedBox(height: 12),
                            _buildStaffStatusItem(
                              icon: Icons.warning,
                              color: Colors.orange,
                              title: 'Leave Requests',
                              subtitle: '3 pending approvals',
                              action: 'Review',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Transport
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Transport',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Icon(Icons.directions_bus, color: Colors.blue, size: 24),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Active Routes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '8 Buses',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                  foregroundColor: Colors.blue.shade700,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('View Live Tracking'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Inventory
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Inventory',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Icon(Icons.inventory, color: Colors.purple, size: 24),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.red.shade600, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Low Stock Alert',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '5 items need reordering',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

              // Messages Tab
              if (_activeTab == 'messages')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Communications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Create Announcement Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.campaign, size: 20),
                              SizedBox(width: 8),
                              Text('Create Announcement'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recent Messages
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Messages',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMessageItem(
                              name: 'Mrs. Anderson',
                              message: 'Regarding Grade 9A exam schedule',
                              time: '2h ago',
                              unread: true,
                            ),
                            const SizedBox(height: 8),
                            _buildMessageItem(
                              name: 'Mr. Thompson',
                              message: 'Leave request submitted',
                              time: '4h ago',
                              unread: true,
                            ),
                            const SizedBox(height: 8),
                            _buildMessageItem(
                              name: 'Parent Group',
                              message: 'Thank you for the update',
                              time: '1d ago',
                              unread: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Broadcast Groups
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Broadcast Groups',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...['All Parents', 'All Teachers', 'Grade 9 Parents', 'Grade 10 Parents'].map((group) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: Colors.grey.shade600,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                group,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF374151),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

              // Profile Tab
              if (_activeTab == 'profile')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Profile & Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Profile Info
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: _cardDecoration(),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Admin User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'admin@edumanage.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Springfield High',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'School Name',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settings Options
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingItem('Notification Settings', Icons.notifications),
                            _buildSettingItem('Language & Region', Icons.settings),
                            _buildSettingItem('Data Export', Icons.description),
                            _buildSettingItem('Help & Support', Icons.message),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF2F2),
                            foregroundColor: const Color(0xFFDC2626),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
            ],
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(
              items: _navItems,
              activeTab: _activeTab,
              onTabChange: (tab) {
                setState(() {
                  _activeTab = tab;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    IconData? trend,
    IconData? alert,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              if (trend != null)
                Icon(trend, color: Colors.green, size: 16)
              else if (alert != null)
                Icon(alert, color: Colors.red, size: 16)
              else if (badge != null)
                  Text(
                    badge,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceRow(String grade, int percentage, String count) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              grade,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
              ),
            ),
            Text(
              '$percentage% ($count)',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }

  Widget _buildExamItem({
    required String subject,
    required String grade,
    required String date,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$grade - $date',
                style: TextStyle(
                  fontSize: 12,
                  color: color.shade700,
                ),
              ),
            ],
          ),
          Icon(
            Icons.calendar_today,
            color: color.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String amount, Color amountColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: amountColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffStatusItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    String? action,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: () {},
              child: Text(
                action,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required bool unread,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: unread ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name[0],
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                                color: unread ? const Color(0xFF374151) : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}