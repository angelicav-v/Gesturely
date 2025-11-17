import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';
import 'profilescreen.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: MODULES GRID SCREEN WIDGET SETUP
// ============================================================================
// Displays all 4 modules in a 2x2 grid format.
// Users can tap any module to view its subsections.
// Alternative to the carousel view on home screen.

class ModulesGridScreen extends StatefulWidget {
  const ModulesGridScreen({super.key});

  @override
  State<ModulesGridScreen> createState() => _ModulesGridScreenState();
}

class _ModulesGridScreenState extends State<ModulesGridScreen> {
  // ========================================================================
  // SECTION 2: MODULE DATA
  // ========================================================================
  // All 4 modules with metadata (colors, images, titles)
  // Each module has:
  // - number: Module ID (1-4)
  // - title: Display name
  // - image: Asset path
  // - gradientStart/End: Background colors
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
  // SECTION 3: UI BUILD METHOD
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
              // SECTION 3.1: TOP HEADER BAR
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
                    // Profile icon button
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
                    // Settings icon button
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

              const SizedBox(height: 20),

              // ================================================================
              // SECTION 3.2: PAGE TITLE
              // ================================================================
              const Text(
                'All Modules',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 24),

              // ================================================================
              // SECTION 3.3: 2x2 GRID OF MODULES
              // ================================================================
              // GridView displays modules in 2 columns
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    // Configure grid: 2 columns, spacing, aspect ratio
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.66,
                        ),
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // Navigate to subsections when module is tapped
                        onTap: () {
                          context.push(
                            '/module-subsections',
                            extra: {
                              'moduleNumber': modules[index]['number'],
                              'moduleName': modules[index]['title'],
                            },
                          );
                        },
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
                            borderRadius: BorderRadius.circular(24),
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
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // ================================================
                              // Module badge with number
                              // ================================================
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: modules[index]['buttonColor'],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: modules[index]['buttonColor']
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Module ${modules[index]['number']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 11),

                              // ================================================
                              // Module image in white container
                              // ================================================
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 60,
                                        offset: const Offset(0, 20),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      modules[index]['image'],
                                      fit: BoxFit.cover,
                                      // Error handler if image not found
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  'Error: $error',
                                                  textAlign: TextAlign.center,
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

                              const SizedBox(height: 12),

                              // ================================================
                              // Module title
                              // ================================================
                              Text(
                                modules[index]['title'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2C3E50),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================================================================
              // SECTION 3.4: BOTTOM NAVIGATION BAR
              // ================================================================
              // Three buttons: Home, Apps (highlighted), Bookmarks
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
                    // Home button - navigate to home
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.home_filled,
                          color: Colors.grey[400],
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Apps button (highlighted - current screen)
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
                      child: Icon(Icons.apps, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 16),
                    // Bookmarks button - navigate to bookmarks
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