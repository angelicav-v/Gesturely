import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';
import 'modulegridscreen.dart';
import 'profilescreen.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: HOME SCREEN WIDGET SETUP
// ============================================================================
// The main landing screen that displays modules in a carousel format.
// Users can swipe through modules and tap to enter a module.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ========================================================================
  // SECTION 2: STATE VARIABLES
  // ========================================================================
  
  // Page controller for the carousel/swipeable modules
  late PageController _pageController;
  
  // Track which module is currently visible (0-3)
  int _currentModule = 0;

  // ========================================================================
  // SECTION 3: MODULE DATA
  // ========================================================================
  // Defines all 4 modules with their metadata (colors, images, titles)
  // Each module has:
  // - number: Module ID (1-4)
  // - title: Display name
  // - image: Asset path to module image
  // - gradientStart/End: Background gradient colors
  // - buttonColor: Color for module badge
  
  final List<Map<String, dynamic>> modules = [
    {
      'number': 1,
      'title': 'Greetings & Introductions',
      'image': 'assets/images/module1greetings.png',
      'gradientStart': Color(0xFFFFEDD4),
      'gradientEnd': Color(0xFFFFD6A7),
      'buttonColor': Color(0xFFFF9500),
    },
    {
      'number': 2,
      'title': 'Places & Directions',
      'image': 'assets/images/module2directions.png',
      'gradientStart': Color(0xFFFFE4E6),
      'gradientEnd': Color(0xFFFCCEE8),
      'buttonColor': Color(0xFFFF69B4),
    },
    {
      'number': 3,
      'title': 'Alphabet & Numbers',
      'image': 'assets/images/module3alphabets.png',
      'gradientStart': Color(0xFFF3E8FF),
      'gradientEnd': Color(0xFFDDD6FF),
      'buttonColor': Color(0xFFBB86FC),
    },
    {
      'number': 4,
      'title': 'Emotions & People',
      'image': 'assets/images/module4emotions.png',
      'gradientStart': Color(0xFFCBFBF1),
      'gradientEnd': Color(0xFFA2F4FD),
      'buttonColor': Color(0xFF00BCD4),
    },
  ];

  // ========================================================================
  // SECTION 4: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Initialize page controller for carousel swiping
    _pageController = PageController();
  }

  @override
  void dispose() {
    // Clean up page controller when widget is destroyed
    _pageController.dispose();
    super.dispose();
  }

  // ========================================================================
  // SECTION 5: UI BUILD METHOD
  // ========================================================================
  
  @override
  Widget build(BuildContext context) {
    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ================================================================
              // SECTION 5.1: TOP HEADER BAR
              // ================================================================
              // Shows profile, app title, and settings icons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile icon button - navigates to profile screen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
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
                    ),
                    // App title with gradient
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
                    // Settings icon button - navigates to settings screen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================================================================
              // SECTION 5.2: MODULE INDICATOR BADGE
              // ================================================================
              // Shows which module (1-4) is currently being viewed
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
                      color: modules[_currentModule]['buttonColor']
                          .withOpacity(0.3),
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

              // ================================================================
              // SECTION 5.3: MAIN MODULE CAROUSEL
              // ================================================================
              // PageView that allows swiping through modules
              // Each page shows a module card with image, title, and tap info
              Expanded(
                flex: 2,
                child: PageView.builder(
                  controller: _pageController,
                  // Update current module when page changes
                  onPageChanged: (index) {
                    setState(() {
                      _currentModule = index;
                    });
                  },
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        // ======================================================
                        // SECTION 5.3.1: MODULE CARD CONTAINER
                        // ======================================================
                        // The main colored card showing module info and image
                        GestureDetector(
                          onTap: () {
                            // Navigate to subsections screen for this module
                            context.push(
                              '/module-subsections',
                              extra: {
                                'moduleNumber': modules[index]['number'],
                                'moduleName': modules[index]['title'],
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 33,
                              vertical: 12,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                // Gradient background
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    modules[index]['gradientStart'],
                                    modules[index]['gradientEnd'],
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
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
                                  // Module title
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
                                  // Tap to explore hint
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
                                  // Module image in white container
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.15),
                                            blurRadius: 60,
                                            offset: const Offset(0, 20),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        child: Image.asset(
                                          modules[index]['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(
                                              color: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  'Error: $error',
                                                  textAlign:
                                                      TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // ======================================================
                        // SECTION 5.3.2: LEFT ARROW BUTTON
                        // ======================================================
                        // Navigate to previous module
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_currentModule > 0) {
                                  _pageController.previousPage(
                                    duration:
                                        const Duration(milliseconds: 400),
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
                        // ======================================================
                        // SECTION 5.3.3: RIGHT ARROW BUTTON
                        // ======================================================
                        // Navigate to next module
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_currentModule < modules.length - 1) {
                                  _pageController.nextPage(
                                    duration:
                                        const Duration(milliseconds: 400),
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

              // ================================================================
              // SECTION 5.4: PROGRESS DOT INDICATORS
              // ================================================================
              // Shows which module is currently selected
              // Large dot for current, small dots for others
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  modules.length,
                  (dotIndex) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    // Current dot is wider (24px), others are small (8px)
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

              // ================================================================
              // SECTION 5.5: BOTTOM NAVIGATION BAR
              // ================================================================
              // Three buttons: Home (highlighted), Apps, Bookmarks
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
                    // Home button (highlighted - current screen)
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
                    // Apps button - navigate to grid view
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ModulesGridScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.apps,
                          color: Colors.grey[400],
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Bookmark button - navigate to bookmarks screen
                    GestureDetector(
                      onTap: () => context.go('/bookmarks'),
                      child: Padding(
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