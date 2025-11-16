import 'package:flutter/material.dart';
import '../widgets/background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentModule = 0;

  final List<Map<String, dynamic>> modules = [
    {
      'number': 1,
      'title': 'Greetings & Introductions',
      'gradientStart': Color(0xFFFFEDD4),
      'gradientEnd': Color(0xFFFFD6A7),
      'buttonColor': Color(0xFFFF9500),
    },
    {
      'number': 2,
      'title': 'Places & Directions',
      'gradientStart': Color(0xFFFFE4E6),
      'gradientEnd': Color(0xFFFCCEE8),
      'buttonColor': Color(0xFFFF69B4),
    },
    {
      'number': 3,
      'title': 'Alphabet & Numbers',
      'gradientStart': Color(0xFFF3E8FF),
      'gradientEnd': Color(0xFFDDD6FF),
      'buttonColor': Color(0xFFBB86FC),
    },
    {
      'number': 4,
      'title': 'Emotions & People',
      'gradientStart': Color(0xFFCBFBF1),
      'gradientEnd': Color(0xFFA2F4FD),
      'buttonColor': Color(0xFF00BCD4),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: const Color(0xFF2C3E50),
                        size: 25,
                      ),
                    ),
                    // Title with gradient
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFF8904),
                          Color(0xFFFF637E),
                          Color(0xFFFB64B6),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Gesturely',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Settings icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        color: const Color(0xFF2C3E50),
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Module button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: modules[_currentModule]['buttonColor'],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: modules[_currentModule]['buttonColor'].withOpacity(
                        0.3,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Module ${_currentModule + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Main card carousel
              Expanded(
                flex: 2,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentModule = index;
                    });
                  },
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        // Colored card background
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 33,
                            vertical: 12,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  modules[index]['gradientStart'],
                                  modules[index]['gradientEnd'],
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 60,
                                  offset: const Offset(0, 20),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              children: [
                                // Title
                                Text(
                                  modules[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C3E50),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                // Subtitle
                                const Text(
                                  'Tap to explore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B7280),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 35),
                                // White content box
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(1.0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Left arrow
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_currentModule > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                  );
                                }
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.chevron_left,
                                  color: const Color(0xFF2C3E50),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Right arrow
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_currentModule < modules.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                  );
                                }
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: const Color(0xFF2C3E50),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  modules.length,
                  (dotIndex) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: dotIndex == _currentModule ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: dotIndex == _currentModule
                          ? const Color(0xFF2C3E50)
                          : const Color.fromARGB(255, 165, 159, 159),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 55),

              // Bottom navigation
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 55,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(65),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Home button (highlighted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF9500), Color(0xFFFF69B4)],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Calendar button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.grey[400],
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Bookmark button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: Colors.grey[400],
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
