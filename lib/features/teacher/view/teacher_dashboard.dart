import 'package:flutter/material.dart';
import '../../../core/widgets/bottom_nav.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  String _activeTab = 'today';

  final List<NavItem> _navItems = [
    NavItem(id: 'today', label: 'Today', icon: Icons.home),
    NavItem(id: 'classes', label: 'Classes', icon: Icons.people),
    NavItem(id: 'assessments', label: 'Assessments', icon: Icons.assignment),
    NavItem(id: 'messages', label: 'Messages', icon: Icons.message),
    NavItem(id: 'more', label: 'More', icon: Icons.more_horiz),
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
                  color: const Color(0xFF2563EB),
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
                            'Ms. Sarah Thompson',
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

              // Today Tab
              if (_activeTab == 'today')
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // Quick Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickStat('5', 'Classes Today'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickStat('94%', 'Avg Attendance'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickStat('12', 'To Grade', color: Colors.orange),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Today's Schedule
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
                                  'Today\'s Schedule',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildScheduleItem(
                              time: '8:00 AM',
                              subject: 'Mathematics',
                              className: 'Grade 9A',
                              room: 'Room 201',
                              status: 'completed',
                            ),
                            _buildScheduleItem(
                              time: '9:30 AM',
                              subject: 'Mathematics',
                              className: 'Grade 9B',
                              room: 'Room 201',
                              status: 'current',
                            ),
                            _buildScheduleItem(
                              time: '11:00 AM',
                              subject: 'Algebra',
                              className: 'Grade 10A',
                              room: 'Room 201',
                              status: 'upcoming',
                            ),
                            _buildScheduleItem(
                              time: '1:00 PM',
                              subject: 'Mathematics',
                              className: 'Grade 10B',
                              room: 'Room 201',
                              status: 'upcoming',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pending Actions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending Actions',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildActionItem(
                              icon: Icons.assignment,
                              color: Colors.orange,
                              title: 'Grade Assignments',
                              subtitle: '12 submissions pending',
                            ),
                            const SizedBox(height: 8),
                            _buildActionItem(
                              icon: Icons.warning,
                              color: Colors.red,
                              title: 'Mark Attendance',
                              subtitle: 'Grade 9A - Today',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),

              // Classes Tab
              if (_activeTab == 'classes')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'My Classes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Class Cards
                      _buildClassCard(
                        className: 'Grade 9A',
                        subject: 'Mathematics',
                        students: 32,
                        time: 'Mon, Wed, Fri - 8:00 AM',
                        avg: 85,
                      ),
                      const SizedBox(height: 16),
                      _buildClassCard(
                        className: 'Grade 9B',
                        subject: 'Mathematics',
                        students: 30,
                        time: 'Mon, Wed, Fri - 9:30 AM',
                        avg: 82,
                      ),
                      const SizedBox(height: 16),
                      _buildClassCard(
                        className: 'Grade 10A',
                        subject: 'Algebra',
                        students: 28,
                        time: 'Tue, Thu - 11:00 AM',
                        avg: 88,
                      ),
                    ]),
                  ),
                ),

              // Assessments Tab
              if (_activeTab == 'assessments')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Assessments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Filter Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Draft', 'Published', 'Closed'].map((filter) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: filter == 'All' ? const Color(0xFF2563EB) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: filter == 'All' ? Colors.transparent : Colors.grey.shade200,
                                  ),
                                ),
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: filter == 'All' ? Colors.white : Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Assignments List
                      _buildAssignmentItem(
                        title: 'Algebra Quiz - Chapter 5',
                        className: 'Grade 10A',
                        dueDate: 'Feb 15, 2026',
                        submissions: '24/28',
                        status: 'published',
                        graded: 12,
                      ),
                      const SizedBox(height: 12),
                      _buildAssignmentItem(
                        title: 'Geometry Assignment',
                        className: 'Grade 9A',
                        dueDate: 'Feb 18, 2026',
                        submissions: '18/32',
                        status: 'published',
                        graded: 0,
                      ),
                      const SizedBox(height: 12),
                      _buildAssignmentItem(
                        title: 'Trigonometry Problem Set',
                        className: 'Grade 10B',
                        dueDate: 'Feb 20, 2026',
                        submissions: '0/31',
                        status: 'draft',
                        graded: 0,
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
                        'Messages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Unread Badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.message, color: Color(0xFF2563EB), size: 20),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'You have 3 unread messages',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Messages List
                      _buildMessageItem(
                        from: 'Mrs. Johnson (Parent)',
                        message: 'Question about homework assignment',
                        time: '1h ago',
                        unread: true,
                      ),
                      const SizedBox(height: 8),
                      _buildMessageItem(
                        from: 'Principal Davis',
                        message: 'Staff meeting tomorrow at 3 PM',
                        time: '3h ago',
                        unread: true,
                      ),
                      const SizedBox(height: 8),
                      _buildMessageItem(
                        from: 'Mr. Anderson (Parent)',
                        message: 'Thank you for the feedback',
                        time: '1d ago',
                        unread: false,
                      ),
                    ]),
                  ),
                ),

              // More Tab
              if (_activeTab == 'more')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'More',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: _cardDecoration(),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'ST',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sarah Thompson',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Mathematics Teacher',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'sarah.thompson@school.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Menu Options
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
                            _buildMenuOption('My Timetable', Icons.calendar_today),
                            _buildMenuOption('Teaching Resources', Icons.menu_book),
                            _buildMenuOption('Performance Analytics', Icons.trending_up),
                            _buildMenuOption('Settings', Icons.settings),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logout
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

  Widget _buildQuickStat(String value, String label, {Color color = Colors.blue}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: color == Colors.orange ? Colors.orange.shade600 : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String subject,
    required String className,
    required String room,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status == 'current'
            ? Colors.blue.shade50
            : status == 'completed'
            ? Colors.grey.shade50
            : Colors.grey.shade50,
        border: status == 'current'
            ? Border.all(color: Colors.blue.shade200, width: 2)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 16),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                      ),
                    ),
                    if (status == 'current')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                    else if (status == 'completed')
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  className,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      room,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
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
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String className,
    required String subject,
    required int students,
    required String time,
    required int avg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.menu_book, color: Colors.blue.shade600, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildClassStat('$students', 'Students'),
              ),
              Expanded(
                child: _buildClassStat('$avg%', 'Class Avg'),
              ),
              Expanded(
                child: _buildClassStat('94%', 'Attendance'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem({
    required String title,
    required String className,
    required String dueDate,
    required String submissions,
    required String status,
    required int graded,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: status == 'published' ? Colors.green.shade100 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: status == 'published' ? Colors.green.shade700 : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      className,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Due: $dueDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.description, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Submitted: $submissions',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$graded graded',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              if (status == 'published')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Grade Now',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({
    required String from,
    required String message,
    required String time,
    required bool unread,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unread ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                from[0],
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
                        from,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                          color: unread ? const Color(0xFF374151) : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(String label, IconData icon) {
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