import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constents/routes_contents.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool _rememberMe = false;
  String? _selectedRole;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<Map<String, dynamic>> _roles = [
    {
      'id': Routes.admin,
      'title': 'Admin',
      'icon': Icons.shield,
      'color': Colors.purple,
    },
    {
      'id': Routes.teacher,
      'title': 'Teacher',
      'icon': Icons.menu_book,
      'color': Colors.blue,
    },
    {
      'id': Routes.student,
      'title': 'Student',
      'icon': Icons.person,
      'color': Colors.green,
    },
    {
      'id': Routes.parent,
      'title': 'Parent',
      'icon': Icons.people,
      'color': Colors.orange,
    },
  ];

 

  bool get _hasCredentials =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // مهم جداً للـ Keyboard
      body: SafeArea(
        child: Stack(
          children: [
            // خلفية التدرج للجزء العلوي
            Container(
              height: screenSize.height * 0.28, // 28% بدلاً من 20%
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                ),
              ),
            ),

            // المحتوى الرئيسي
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 100,
              ), // مساحة للـ Bottom Section
              child: Column(
                children: [
                  // الهيدر مع الشعار والنص
                  SizedBox(
                    height: screenSize.height * 0.28,
                    child: Stack(
                      children: [
                        // Language Toggle
                       // Logo & Welcome
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Color(0xFF2563EB),
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Welcome to Springfield High',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Transform.translate
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Input
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email or Phone',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email or phone',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF9CA3AF),
                                    size: 20,
                                  ),
                                  suffixIcon: _emailController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear,
                                            size: 18,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                          onPressed: () {
                                            setState(
                                              () => _emailController.clear(),
                                            );
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF2563EB),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Password Input
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF9CA3AF),
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF9CA3AF),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _showPassword = !_showPassword,
                                      );
                                    },
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF2563EB),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Role Selection
                          if (_hasCredentials) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Select your role:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: List.generate(_roles.length, (index) {
                                final role = _roles[index];
                                final isSelected = _selectedRole == role['id'];

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = role['id'] as String;
                                        
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: EdgeInsets.only(
                                        right: index == _roles.length - 1
                                            ? 0
                                            : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (role['color'] as Color)
                                                  .withOpacity(0.1)
                                            : Colors.white,
                                        border: Border.all(
                                          color: isSelected
                                              ? role['color'] as Color
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              role['icon'] as IconData,
                                              size: 24,
                                              color: isSelected
                                                  ? role['color'] as Color
                                                  : Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              role['title'] as String,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isSelected
                                                    ? role['color'] as Color
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],

                       

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Bottom Fixed Section
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Remember Me
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _hasCredentials && _selectedRole != null
                              ? () {
                                  String route = '/';
                                  switch (_selectedRole) {
                                    case '/admin':
                                      route = Routes.admin;
                                      break;
                                    case '/teacher':
                                      route = Routes.teacher;
                                      break;
                                    case '/student':
                                      route = Routes.student;
                                      break;
                                    case '/parent':
                                      route = Routes.parent;
                                      break;
                                  }
                                 context.go(route);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(
                              0xFF2563EB,
                            ).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _selectedRole == null
                                ? 'Sign In'
                                : 'Continue as ${_roles.firstWhere((r) => r['id'] == _selectedRole)['title']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                     

                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
