import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';
import 'flashcardscreen.dart' show ProgressTracker;
import 'profilescreen.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: MODULE SUBSECTIONS SCREEN WIDGET SETUP
// ============================================================================
// Shows all subsections within a specific module.
// Displays progress bars for each subsection.
// Users can tap to start learning a subsection.

class ModuleSubsectionsScreen extends StatefulWidget {
  final int moduleNumber;
  final String moduleName;

  const ModuleSubsectionsScreen({
    super.key,
    required this.moduleNumber,
    required this.moduleName,
  });

  @override
  State<ModuleSubsectionsScreen> createState() =>
      _ModuleSubsectionsScreenState();
}

class _ModuleSubsectionsScreenState extends State<ModuleSubsectionsScreen> {
  // ========================================================================
  // SECTION 2: STATE VARIABLES
  // ========================================================================
  
  // List of subsections for this module
  late List<Map<String, dynamic>> subsections;

  // ========================================================================
  // SECTION 3: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Get subsections for this module
    subsections = _getSubsections();
    // Update progress display
    _updateProgress();
  }

  @override
  void didUpdateWidget(ModuleSubsectionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If module changed, reload subsections
    subsections = _getSubsections();
    _updateProgress();
  }

  // ========================================================================
  // SECTION 4: DATA RETRIEVAL METHODS
  // ========================================================================
  
  /// Get all subsections for this module
  /// 
  /// Returns different subsections based on moduleNumber:
  /// - Module 1: Common Phrases, Greetings
  /// - Module 2: Directions
  /// - Module 3: Numbers, Alphabet
  /// - Module 4: Emotions, People
  List<Map<String, dynamic>> _getSubsections() {
    switch (widget.moduleNumber) {
      case 1:
        return [
          {
            'number': 1,
            'title': 'Common Phrases',
            'cardCount': 15,
            'progress': 0.0,
            'color': Color(0xFFFF69B4),
            'cards': [
              "I don't know", 'Learn', "You're welcome", 'Thank you', 'Please',
              'Sorry', 'Yes', 'Why', 'No', 'Me too / Same', 'Always', 'Never',
              'Wrong / Mistake', 'Idea', 'Know',
            ],
          },
          {
            'number': 2,
            'title': 'Greetings & Introductions',
            'cardCount': 9,
            'progress': 0.0,
            'color': Color(0xFF3B82F6),
            'cards': [
              'Goodnight', 'Goodmorning', 'Nice to meet you', "What's up?",
              'What is your name?', 'My name is …', 'Bye (pt.1)', 'Bye (pt.2)',
              'Hello',
            ],
          },
        ];
      case 2:
        return [
          {
            'number': 1,
            'title': 'Directions',
            'cardCount': 7,
            'progress': 0.0,
            'color': Color(0xFF10B981),
            'cards': [
              'Left', 'North', 'South', 'East', 'West', 'Right', 'Where',
            ],
          },
        ];
      case 3:
        return [
          {
            'number': 1,
            'title': 'Numbers 1-10',
            'cardCount': 10,
            'progress': 0.0,
            'color': Color(0xFF10B981),
            'cards': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
          },
          {
            'number': 2,
            'title': "ABC's",
            'cardCount': 26,
            'progress': 0.0,
            'color': Color(0xFFF59E0B),
            'cards': [
              'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
              'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            ],
          },
        ];
      case 4:
        return [
          {
            'number': 1,
            'title': 'Emotions',
            'cardCount': 6,
            'progress': 0.0,
            'color': Color(0xFF10B981),
            'cards': [
              'Surprised', 'Hungry', 'Tired', 'Angry', 'Worried', 'Happy',
            ],
          },
          {
            'number': 2,
            'title': 'People',
            'cardCount': 18,
            'progress': 0.0,
            'color': Color(0xFFF59E0B),
            'cards': [
              'Sister (pt.1)', 'Sister (pt.2)', 'Brother (pt.1)', 'Brother (pt.2)',
              'Mother', 'Father', 'Grandma (pt.1)', 'Grandma (pt.2)',
              'Grandpa (pt.1)', 'Grandpa (pt.2)', 'Girl (pt.1)', 'Girl (pt.2)',
              'Boy (pt.1)', 'Boy (pt.2)', 'Woman (pt.1)', 'Woman (pt.2)',
              'Man (pt.1)', 'Man (pt.2)',
            ],
          },
        ];
      default:
        return [];
    }
  }

  /// Update progress display for each subsection
  /// 
  /// Fetches progress from ProgressTracker and updates the UI
  void _updateProgress() {
    setState(() {
      for (var subsection in subsections) {
        final key = '${widget.moduleNumber}_${subsection['number']}';
        final progress = ProgressTracker.getProgress(key);
        subsection['progress'] = progress;
      }
    });
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

              const SizedBox(height: 16),

              // ================================================================
              // SECTION 5.2: MODULE HEADER
              // ================================================================
              // Shows back button and module name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                    const SizedBox(width: 12),
                    // Module name
                    Expanded(
                      child: Text(
                        widget.moduleName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 63),

              // ================================================================
              // SECTION 5.3: SUBSECTIONS LIST
              // ================================================================
              // ListView showing each subsection with progress bar
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: subsections.length,
                  itemBuilder: (context, index) {
                    final subsection = subsections[index];
                    // Convert progress to percentage
                    final progressPercent = (subsection['progress'] * 100)
                        .toStringAsFixed(0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        // Navigate to flashcards for this subsection
                        onTap: () {
                          context.push(
                            '/flashcards',
                            extra: {
                              'moduleNumber': widget.moduleNumber,
                              'subsectionNumber': subsection['number'],
                              'subsectionTitle': subsection['title'],
                              'cardCount': subsection['cardCount'],
                              'cards': subsection['cards'] ?? [],
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ================================================
                              // SECTION 5.3.1: SUBSECTION TITLE & CARD COUNT
                              // ================================================
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Subsection title
                                  Expanded(
                                    child: Text(
                                      subsection['title'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Card count badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: subsection['color']
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${subsection['cardCount']} cards',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: subsection['color'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // ================================================
                              // SECTION 5.3.2: PROGRESS LABEL & PERCENTAGE
                              // ================================================
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  Text(
                                    '$progressPercent%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // ================================================
                              // SECTION 5.3.3: PROGRESS BAR
                              // ================================================
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: subsection['progress'],
                                  minHeight: 6,
                                  backgroundColor:
                                      subsection['color'].withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    subsection['color'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================================================================
              // SECTION 5.4: BOTTOM NAVIGATION BAR
              // ================================================================
              // Two buttons: Layers (highlighted), Copy (quick start)
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
                    // Layers icon (highlighted - current screen)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFF8904),
                            Color(0xFFFF637E),
                            Color(0xFFFB64B6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.layers, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 8),
                    // Copy icon - quick start first subsection
                    GestureDetector(
                      onTap: () {
                        if (subsections.isNotEmpty) {
                          final firstSubsection = subsections[0];
                          context.push(
                            '/flashcards',
                            extra: {
                              'moduleNumber': widget.moduleNumber,
                              'subsectionNumber': firstSubsection['number'],
                              'subsectionTitle': firstSubsection['title'],
                              'cardCount': firstSubsection['cardCount'],
                              'cards': firstSubsection['cards'] ?? [],
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Icon(
                          Icons.copy,
                          color: Colors.grey[400],
                          size: 24,
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