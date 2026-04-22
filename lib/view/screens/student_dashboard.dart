import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String _activeTab = 'home';

  final List<NavItem> _navItems = [
    NavItem(id: 'home', label: 'Home', icon: Icons.home),
    NavItem(id: 'schedule', label: 'Schedule', icon: Icons.calendar_today),
    NavItem(id: 'assignments', label: 'Assignments', icon: Icons.assignment),
    NavItem(id: 'grades', label: 'Grades', icon: Icons.grade),
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
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Alex Johnson',
                            style: TextStyle(
                              color: Color(0xFFBFDBFE),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Icon(Icons.notifications, color: Colors.white, size: 24),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Home Tab
              if (_activeTab == 'home')
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // Next Class Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.purpleAccent],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Next Class',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'In 25 mins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Mathematics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Icon(Icons.person, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Ms. Thompson',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.location_on, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Room 201',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.access_time, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '9:30 AM',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.grade,
                              color: Colors.green,
                              value: '85.5%',
                              label: 'Overall Average',
                              trend: Icons.trending_up,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.check_circle,
                              color: Colors.blue,
                              value: '46/48',
                              label: 'Attendance Rate',
                              badge: '96%',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Pending Assignments
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
                                  'Pending Assignments',
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
                            _buildAssignmentItem(
                              title: 'Algebra Quiz - Chapter 5',
                              subject: 'Mathematics',
                              dueDate: 'Due Feb 15',
                              urgent: true,
                            ),
                            const SizedBox(height: 8),
                            _buildAssignmentItem(
                              title: 'Essay: Climate Change',
                              subject: 'English',
                              dueDate: 'Due Feb 18',
                              urgent: false,
                            ),
                            const SizedBox(height: 8),
                            _buildAssignmentItem(
                              title: 'Lab Report: Chemical Reactions',
                              subject: 'Chemistry',
                              dueDate: 'Submitted Feb 8',
                              urgent: false,
                              submitted: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Recent Grades
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
                                  'Recent Grades',
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
                            _buildGradeItem(
                              subject: 'Mathematics',
                              grade: 92,
                              date: 'Feb 8',
                              trend: 'up',
                            ),
                            const SizedBox(height: 8),
                            _buildGradeItem(
                              subject: 'Physics',
                              grade: 88,
                              date: 'Feb 7',
                              trend: 'up',
                            ),
                            const SizedBox(height: 8),
                            _buildGradeItem(
                              subject: 'English',
                              grade: 78,
                              date: 'Feb 5',
                              trend: 'down',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Links
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildQuickLink(Icons.calendar_today, 'Timetable', Colors.blue),
                          _buildQuickLink(Icons.local_library, 'Library', Colors.purple),
                          _buildQuickLink(Icons.directions_bus, 'Transport', Colors.orange),
                          _buildQuickLink(Icons.notifications, 'Notifications', Colors.red),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),

              // Schedule Tab
              if (_activeTab == 'schedule')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Weekly Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Day Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map((day) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: day == 'Tue' ? const Color(0xFF2563EB) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: day == 'Tue' ? Colors.transparent : Colors.grey.shade200,
                                  ),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: day == 'Tue' ? Colors.white : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Schedule Timeline
                      _buildScheduleLesson(
                        time: '8:00 AM',
                        subject: 'Mathematics',
                        teacher: 'Ms. Thompson',
                        room: 'Room 201',
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleLesson(
                        time: '9:30 AM',
                        subject: 'Physics',
                        teacher: 'Mr. Anderson',
                        room: 'Lab 2',
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleLesson(
                        time: '11:00 AM',
                        subject: 'English',
                        teacher: 'Mrs. Davis',
                        room: 'Room 105',
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleLesson(
                        time: '1:00 PM',
                        subject: 'Chemistry',
                        teacher: 'Dr. Wilson',
                        room: 'Lab 1',
                      ),

                      const SizedBox(height: 24),

                      // Exam Countdown
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upcoming Exam',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Mathematics Final',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '5 days remaining - Feb 15, 2026',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                            Icon(Icons.warning, color: Colors.white, size: 24),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),

              // Assignments Tab
              if (_activeTab == 'assignments')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Assignments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Filter Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Pending', 'Submitted', 'Graded'].map((filter) {
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
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Assignments List
                      _buildFullAssignmentItem(
                        title: 'Algebra Quiz - Chapter 5',
                        subject: 'Mathematics',
                        dueDate: 'Due Feb 15',
                        status: 'pending',
                        points: 100,
                      ),
                      const SizedBox(height: 12),
                      _buildFullAssignmentItem(
                        title: 'Essay: Climate Change',
                        subject: 'English',
                        dueDate: 'Due Feb 18',
                        status: 'pending',
                        points: 50,
                      ),
                      const SizedBox(height: 12),
                      _buildFullAssignmentItem(
                        title: 'Lab Report: Chemical Reactions',
                        subject: 'Chemistry',
                        dueDate: 'Submitted Feb 8',
                        status: 'submitted',
                        points: 75,
                      ),
                      const SizedBox(height: 12),
                      _buildFullAssignmentItem(
                        title: 'Physics Problem Set 3',
                        subject: 'Physics',
                        dueDate: 'Graded Feb 7',
                        status: 'graded',
                        points: 88,
                        grade: 88,
                      ),
                    ]),
                  ),
                ),

              // Grades Tab
              if (_activeTab == 'grades')
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'My Grades',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Overall Average
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Overall Average',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '85.5%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.trending_up, color: Colors.white, size: 24),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '+3.2% from last term',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Subject Grades
                      _buildSubjectGrade(
                        subject: 'Mathematics',
                        grade: 92,
                        classAvg: 85,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildSubjectGrade(
                        subject: 'Physics',
                        grade: 88,
                        classAvg: 82,
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 12),
                      _buildSubjectGrade(
                        subject: 'Chemistry',
                        grade: 85,
                        classAvg: 80,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildSubjectGrade(
                        subject: 'English',
                        grade: 78,
                        classAvg: 83,
                        color: Colors.orange,
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
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'AJ',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Alex Johnson',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Grade 9A',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Student ID: STU-2024-1248',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Options
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
                            _buildOptionItem('Transport Tracking', Icons.directions_bus),
                            _buildOptionItem('Library', Icons.local_library),
                            _buildOptionItem('Notifications', Icons.notifications),
                            _buildOptionItem('Profile Settings', Icons.person),
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

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    IconData? trend,
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

  Widget _buildAssignmentItem({
    required String title,
    required String subject,
    required String dueDate,
    required bool urgent,
    bool submitted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: submitted
            ? Colors.green.shade50
            : urgent
            ? Colors.red.shade50
            : Colors.grey.shade50,
        border: Border.all(
          color: submitted
              ? Colors.green.shade200
              : urgent
              ? Colors.red.shade200
              : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
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
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: submitted
                        ? Colors.green
                        : urgent
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (urgent)
            const Icon(Icons.warning, color: Colors.red, size: 20)
          else if (submitted)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildGradeItem({
    required String subject,
    required int grade,
    required String date,
    required String trend,
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu_book, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
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
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                trend == 'up' ? Icons.trending_up : Icons.trending_down,
                color: trend == 'up' ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$grade%',
                style: TextStyle(
                  fontSize: 18,
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
        ],
      ),
    );
  }

  Widget _buildQuickLink(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleLesson({
    required String time,
    required String subject,
    required String teacher,
    required String room,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.access_time, color: Colors.grey, size: 20),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      teacher,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      room,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildFullAssignmentItem({
    required String title,
    required String subject,
    required String dueDate,
    required String status,
    required int points,
    int? grade,
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
                    Text(
                      title,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'pending'
                      ? Colors.orange.shade100
                      : status == 'submitted'
                      ? Colors.blue.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: status == 'pending'
                        ? Colors.orange.shade700
                        : status == 'submitted'
                        ? Colors.blue.shade700
                        : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (status == 'pending')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              else if (status == 'graded' && grade != null)
                Text(
                  'Grade: $grade/$points',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGrade({
    required String subject,
    required int grade,
    required int classAvg,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book, color: color.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    grade > classAvg ? Icons.trending_up : Icons.trending_down,
                    color: grade > classAvg ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$grade%',
                    style: TextStyle(
                      fontSize: 20,
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Class Average',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                '$classAvg%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: grade / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              grade >= 90
                  ? Colors.green
                  : grade >= 80
                  ? Colors.blue
                  : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(String label, IconData icon) {
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