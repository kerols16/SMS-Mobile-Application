import 'package:flutter/material.dart';
import '../../../core/widgets/bottom_nav.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  String _activeTab = 'overview';
  String _selectedChildId = '1';
  bool _showChildSelector = false;
  bool _showBusTracker = false;
  bool _showReportCard = false;

  final List<Map<String, dynamic>> _children = [
    {'id': '1', 'name': 'Alex Johnson', 'grade': 'Grade 9A', 'avatar': 'AJ', 'attendance': 96, 'avgGrade': 85.5},
    {'id': '2', 'name': 'Emma Johnson', 'grade': 'Grade 7B', 'avatar': 'EJ', 'attendance': 98, 'avgGrade': 92.3},
  ];

  Map<String, dynamic> get _selectedChild =>
      _children.firstWhere((c) => c['id'] == _selectedChildId);

  final List<NavItem> _navItems = [
    NavItem(id: 'overview', label: 'Overview', icon: Icons.home),
    NavItem(id: 'academics', label: 'Academics', icon: Icons.menu_book),
    NavItem(id: 'finance', label: 'Finance', icon: Icons.attach_money),
    NavItem(id: 'communication', label: 'Messages', icon: Icons.message),
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Parent Portal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Monitor your child\'s progress',
                                style: TextStyle(
                                  color: Color(0xFFFFE4E6),
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
                      const SizedBox(height: 16),

                      // Child Selector
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showChildSelector = !_showChildSelector;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _selectedChild['avatar'],
                                        style: const TextStyle(
                                          color: Colors.white,
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
                                        Text(
                                          _selectedChild['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          _selectedChild['grade'],
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    _showChildSelector
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Dropdown
                          if (_showChildSelector)
                            Positioned(
                              top: 70,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: _children.map((child) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedChildId = child['id'];
                                          _showChildSelector = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade100,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: child['id'] == _selectedChildId
                                                    ? Colors.blue.shade200
                                                    : Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  child['avatar'],
                                                  style: TextStyle(
                                                    color: child['id'] == _selectedChildId
                                                        ? Colors.blue.shade700
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    child['name'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF374151),
                                                    ),
                                                  ),
                                                  Text(
                                                    child['grade'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (child['id'] == _selectedChildId)
                                              const Icon(
                                                Icons.check_circle,
                                                color: Color(0xFF2563EB),
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Overview Tab
              if (_activeTab == 'overview')
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // Child Summary Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: _cardDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.blue, Colors.lightBlue],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _selectedChild['avatar'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedChild['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_selectedChild['grade']} • Student ID: STU-${_selectedChild['id']}248',
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
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_selectedChild['attendance']}%',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const Text(
                                      'Attendance',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.star, color: Colors.blue, size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_selectedChild['avgGrade']}%',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const Text(
                                      'Avg Grade',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.attach_money, color: Colors.orange, size: 20),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const Text(
                                      'Fee Status',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                Text(
                                  'Friday, Feb 13',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildScheduleItem(
                              time: '08:00 AM',
                              subject: 'Mathematics',
                              room: 'Room 301',
                              status: 'completed',
                            ),
                            const SizedBox(height: 8),
                            _buildScheduleItem(
                              time: '09:30 AM',
                              subject: 'Physics',
                              room: 'Lab 2',
                              status: 'completed',
                            ),
                            const SizedBox(height: 8),
                            _buildScheduleItem(
                              time: '11:00 AM',
                              subject: 'English',
                              room: 'Room 205',
                              status: 'ongoing',
                            ),
                            const SizedBox(height: 8),
                            _buildScheduleItem(
                              time: '01:00 PM',
                              subject: 'Chemistry',
                              room: 'Lab 1',
                              status: 'upcoming',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Homework Overview
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
                                  'Pending Homework',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildHomeworkItem(
                              title: 'Algebra Practice Set',
                              subject: 'Mathematics',
                              dueDate: 'Due Feb 16',
                              priority: 'high',
                            ),
                            const SizedBox(height: 8),
                            _buildHomeworkItem(
                              title: 'Essay on Climate Change',
                              subject: 'English',
                              dueDate: 'Due Feb 18',
                              priority: 'medium',
                            ),
                            const SizedBox(height: 8),
                            _buildHomeworkItem(
                              title: 'Lab Report',
                              subject: 'Physics',
                              dueDate: 'Due Feb 14',
                              priority: 'low',
                              status: 'submitted',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Bus Tracking
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showBusTracker = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(Icons.directions_bus, color: Colors.white, size: 24),
                                        SizedBox(width: 8),
                                        Text(
                                          'School Bus',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Bus #7 - Route A',
                                      style: TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Driver: John Smith',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Icon(Icons.access_time, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '15 mins',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Estimated arrival',
                                          style: TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Track Live',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildQuickAction(
                            icon: Icons.description,
                            iconColor: Colors.blue,
                            label: 'Report Card',
                            subtitle: 'View grades',
                            onTap: () {
                              setState(() {
                                _showReportCard = true;
                              });
                            },
                          ),
                          _buildQuickAction(
                            icon: Icons.calendar_today,
                            iconColor: Colors.purple,
                            label: 'Schedule',
                            subtitle: 'View timetable',
                            onTap: () {},
                          ),
                          _buildQuickAction(
                            icon: Icons.message,
                            iconColor: Colors.green,
                            label: 'Message',
                            subtitle: 'Contact teacher',
                            onTap: () {},
                          ),
                          _buildQuickAction(
                            icon: Icons.favorite,
                            iconColor: Colors.red,
                            label: 'Health',
                            subtitle: 'Medical records',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Recent Alerts
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
                                  'Recent Alerts',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildAlertItem(
                              icon: Icons.check_circle,
                              color: Colors.green,
                              title: 'Assignment submitted',
                              subtitle: 'Mathematics Quiz - Feb 8',
                            ),
                            const SizedBox(height: 8),
                            _buildAlertItem(
                              icon: Icons.star,
                              color: Colors.blue,
                              title: 'New grade posted',
                              subtitle: 'Physics Test - 88%',
                            ),
                            const SizedBox(height: 8),
                            _buildAlertItem(
                              icon: Icons.warning,
                              color: Colors.orange,
                              title: 'Upcoming assignment',
                              subtitle: 'English Essay due Feb 18',
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
                        'Academic Performance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Performance Overview
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlue],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Overall Performance',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_selectedChild['avgGrade']}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.trending_up, color: Colors.white, size: 24),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Above class average (82%)',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Attendance Calendar
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
                                  'Attendance This Month',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Text(
                                  '${_selectedChild['attendance']}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.count(
                              crossAxisCount: 7,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(28, (index) {
                                return Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: index % 7 == 0 || index % 7 == 6
                                        ? Colors.grey.shade100
                                        : index == 5 || index == 12
                                        ? Colors.red.shade100
                                        : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: index % 7 == 0 || index % 7 == 6
                                            ? Colors.grey
                                            : index == 5 || index == 12
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 12, height: 12, color: Colors.green.shade100),
                                    const SizedBox(width: 4),
                                    const Text('Present (26)', style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(width: 12, height: 12, color: Colors.red.shade100),
                                    const SizedBox(width: 4),
                                    const Text('Absent (2)', style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(width: 12, height: 12, color: Colors.grey.shade100),
                                    const SizedBox(width: 4),
                                    const Text('Weekend', style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Subject Performance
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Subject Grades',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSubjectGrade(
                              subject: 'Mathematics',
                              grade: 92,
                              classAvg: 85,
                              trend: 'up',
                              teacher: 'Ms. Thompson',
                            ),
                            const SizedBox(height: 12),
                            _buildSubjectGrade(
                              subject: 'Physics',
                              grade: 88,
                              classAvg: 82,
                              trend: 'up',
                              teacher: 'Dr. Wilson',
                            ),
                            const SizedBox(height: 12),
                            _buildSubjectGrade(
                              subject: 'Chemistry',
                              grade: 85,
                              classAvg: 80,
                              trend: 'same',
                              teacher: 'Mrs. Brown',
                            ),
                            const SizedBox(height: 12),
                            _buildSubjectGrade(
                              subject: 'English',
                              grade: 78,
                              classAvg: 83,
                              trend: 'down',
                              teacher: 'Mrs. Davis',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Teacher Comments
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Teacher Comments',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCommentItem(
                              teacher: 'Mathematics - Ms. Thompson',
                              comment: 'Alex shows excellent problem-solving skills.',
                              date: 'Feb 8',
                            ),
                            const SizedBox(height: 8),
                            _buildCommentItem(
                              teacher: 'English - Mrs. Davis',
                              comment: 'More effort needed on essay writing.',
                              date: 'Feb 5',
                            ),
                            const SizedBox(height: 8),
                            _buildCommentItem(
                              teacher: 'Physics - Dr. Wilson',
                              comment: 'Outstanding performance in lab work.',
                              date: 'Feb 3',
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

              // Finance Tab
              if (_activeTab == 'finance')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Fee Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Fee Summary
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Current Status',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'All Paid',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'No pending payments',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 48,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Fee Breakdown
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fee Breakdown (Current Term)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFeeRow('Tuition Fee', '\$2,500.00'),
                            _buildFeeRow('Transport Fee', '\$150.00'),
                            _buildFeeRow('Activity Fee', '\$100.00'),
                            _buildFeeRow('Library Fee', '\$50.00'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Total Paid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Text(
                                  '\$2,800.00',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Payment History
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
                                  'Payment History',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentItem(
                              date: 'Jan 5, 2026',
                              amount: '\$2,800.00',
                              method: 'Credit Card',
                            ),
                            const SizedBox(height: 8),
                            _buildPaymentItem(
                              date: 'Oct 5, 2025',
                              amount: '\$2,800.00',
                              method: 'Bank Transfer',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Payment Button
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
                              Icon(Icons.credit_card, size: 20),
                              SizedBox(width: 8),
                              Text('Make Payment'),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

              // Communication Tab
              if (_activeTab == 'communication')
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

                      // New Message Button
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
                              Icon(Icons.message, size: 20),
                              SizedBox(width: 8),
                              Text('New Message'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Teacher Contacts
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedChild['name']}\'s Teachers',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTeacherContact(
                              name: 'Ms. Sarah Thompson',
                              subject: 'Mathematics',
                            ),
                            const SizedBox(height: 8),
                            _buildTeacherContact(
                              name: 'Dr. Robert Wilson',
                              subject: 'Physics',
                            ),
                            const SizedBox(height: 8),
                            _buildTeacherContact(
                              name: 'Mrs. Linda Davis',
                              subject: 'English',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recent Conversations
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Conversations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildConversationItem(
                              name: 'Ms. Thompson (Mathematics)',
                              message: 'Alex is doing great in class!',
                              time: '2h ago',
                              unread: true,
                            ),
                            const SizedBox(height: 8),
                            _buildConversationItem(
                              name: 'School Administration',
                              message: 'Parent-teacher meeting on Feb 12',
                              time: '1d ago',
                              unread: true,
                            ),
                            const SizedBox(height: 8),
                            _buildConversationItem(
                              name: 'Mrs. Davis (English)',
                              message: 'Thanks for your support',
                              time: '2d ago',
                              unread: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // School Announcements
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'School Announcements',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildAnnouncementItem(
                              title: 'Winter Break Schedule',
                              date: 'Feb 7',
                              message: 'School will be closed from Feb 20-28 for winter break.',
                            ),
                            const SizedBox(height: 8),
                            _buildAnnouncementItem(
                              title: 'Sports Day Event',
                              date: 'Feb 5',
                              message: 'Annual sports day on March 15. Parents are invited!',
                            ),
                          ],
                        ),
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
                        'More Options',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Parent Profile
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: _cardDecoration(),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.deepOrange],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'MJ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Michael Johnson',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Parent Account',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'michael.j@email.com',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            const Text(
                              'Managing 2 children',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _children.map((child) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      child['avatar'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // More Options
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
                            _buildMoreOption('Transport Tracking', Icons.directions_bus, badge: 'Live'),
                            _buildMoreOption('School Calendar', Icons.calendar_today),
                            _buildMoreOption('Health Records', Icons.favorite),
                            _buildMoreOption('Document Vault', Icons.description, badge: '8'),
                            _buildMoreOption('Emergency Contacts', Icons.phone),
                            _buildMoreOption('Leave Application', Icons.check_box),
                            _buildMoreOption('Settings & Privacy', Icons.settings),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Help & Support
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Need Help?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Contact school administration or check our FAQ section.',
                                    style: TextStyle(fontSize: 12, color: Colors.blue),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Contact Support',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'View FAQ',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                          child: const Text('Logout from Parent Portal'),
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

          // Bus Tracker Modal
          if (_showBusTracker)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Live Bus Tracking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showBusTracker = false;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Bus is on the way',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Estimated arrival: 15 minutes',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Current Location: Oak Street'),
                                SizedBox(height: 4),
                                Text('Driver: John Smith'),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'On Schedule',
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Report Card Modal
          if (_showReportCard)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Report Card',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showReportCard = false;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Report Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlue],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Academic Year 2025-2026',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Fall Semester Report',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_selectedChild['name']} • ${_selectedChild['grade']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // GPA
                            Row(
                              children: [
                                Expanded(
                                  child: _buildReportStat('${_selectedChild['avgGrade']}%', 'Overall GPA'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildReportStat('A', 'Grade'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildReportStat('5th', 'Class Rank'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Subject Breakdown
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: _cardDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Subject Breakdown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildReportSubject('Mathematics', 92, 'A'),
                                  _buildReportSubject('Physics', 88, 'B+'),
                                  _buildReportSubject('Chemistry', 85, 'B'),
                                  _buildReportSubject('English', 78, 'C+'),
                                  _buildReportSubject('History', 90, 'A-'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Teacher's Remark
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                border: Border.all(color: Colors.purple.shade200),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Class Teacher\'s Remark:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '"Alex has shown excellent progress this semester. Strong performance in sciences with room for improvement in language arts."',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ms. Jennifer Anderson - Class Teacher',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Download Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download),
                                label: const Text('Download PDF'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String subject,
    required String room,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: status == 'completed'
                  ? Colors.green
                  : status == 'ongoing'
                  ? Colors.blue
                  : Colors.grey,
              borderRadius: BorderRadius.circular(2),
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
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
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
                  room,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (status == 'ongoing')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Live',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeworkItem({
    required String title,
    required String subject,
    required String dueDate,
    required String priority,
    String status = 'pending',
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priority == 'high'
            ? Colors.red.shade50
            : priority == 'medium'
            ? Colors.orange.shade50
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: priority == 'high'
                ? Colors.red
                : priority == 'medium'
                ? Colors.orange
                : Colors.blue,
            width: 4,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dueDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'submitted'
                      ? Colors.green.shade100
                      : priority == 'high'
                      ? Colors.red.shade100
                      : priority == 'medium'
                      ? Colors.orange.shade100
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status == 'submitted' ? 'Submitted' : 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    color: status == 'submitted'
                        ? Colors.green.shade700
                        : priority == 'high'
                        ? Colors.red.shade700
                        : priority == 'medium'
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
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

  Widget _buildSubjectGrade({
    required String subject,
    required int grade,
    required int classAvg,
    required String trend,
    required String teacher,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    trend == 'up'
                        ? Icons.trending_up
                        : trend == 'down'
                        ? Icons.trending_down
                        : Icons.horizontal_rule,
                    color: trend == 'up'
                        ? Colors.green
                        : trend == 'down'
                        ? Colors.red
                        : Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              Text(
                '$grade%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: grade >= 90
                      ? Colors.green
                      : grade >= 80
                      ? Colors.blue
                      : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Class avg: $classAvg%',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                teacher,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required String teacher,
    required String comment,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  teacher,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 8, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String date,
    required String amount,
    required String method,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  method,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherContact({
    required String name,
    required String subject,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
                name.split(' ').map((e) => e[0]).join(),
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subject,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildConversationItem({
    required String name,
    required String message,
    required String time,
    required bool unread,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unread ? Colors.blue.shade50 : Colors.grey.shade50,
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

  Widget _buildAnnouncementItem({
    required String title,
    required String date,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: Colors.purple.shade500, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Text(
                date,
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
    );
  }

  Widget _buildMoreOption(String label, IconData icon, {String? badge}) {
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
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: badge == 'Live' ? Colors.green.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        color: badge == 'Live' ? Colors.green.shade700 : Colors.blue.shade700,
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

  Widget _buildReportStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSubject(String subject, int grade, String letter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subject,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
          ),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$grade%',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
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