import 'package:flutter/material.dart';
import '../widgets/background.dart';
import 'flashcardscreen.dart' show ProgressTracker, BookmarksTracker;

// ============================================================================
// SECTION 1: PROFILE SCREEN WIDGET SETUP
// ============================================================================
// Shows user profile information, statistics, and learning progress.
// Displays bookmarks count, cards learned, and progress per module.

class ProfileScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const ProfileScreen({
    super.key,
    this.userName = 'Sarah Johnson',
    this.userEmail = 'sarah.j@email.com',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ========================================================================
  // SECTION 2: STATE VARIABLES
  // ========================================================================
  
  // Track number of cards learned
  int _cardsLearned = 0;
  
  // Track number of bookmarks
  int _bookmarksCount = 0;

  // ========================================================================
  // SECTION 3: MODULE DATA
  // ========================================================================
  // List of all modules with their metadata
  
  final List<Map<String, dynamic>> modules = [
    {
      'number': 1,
      'title': 'Greetings & Introductions',
      'color': Color(0xFFFF9500),
    },
    {
      'number': 2,
      'title': 'Places & Directions',
      'color': Color(0xFFFF69B4),
    },
    {
      'number': 3,
      'title': 'Alphabet & Numbers',
      'color': Color(0xFFBB86FC),
    },
    {
      'number': 4,
      'title': 'Emotions & People',
      'color': Color(0xFF00BCD4),
    },
  ];

  // ========================================================================
  // SECTION 4: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Calculate and update statistics on screen load
    _updateStats();
  }

  // ========================================================================
  // SECTION 5: STATISTICS CALCULATION METHODS
  // ========================================================================
  
  /// Calculate and update user statistics
  /// 
  /// Updates:
  /// - Total bookmarks count
  /// - Total cards learned (estimated from progress)
  void _updateStats() {
    setState(() {
      // Count all bookmarks from BookmarksTracker
      _bookmarksCount = BookmarksTracker.getBookmarks().length;

      // Calculate total cards learned based on module progress
      int total = 0;
      // Loop through all modules (1-4)
      for (int i = 1; i <= 4; i++) {
        // Loop through all subsections (1-2)
        for (int j = 1; j <= 2; j++) {
          final key = '${i}_$j';
          // Get progress for this module/subsection
          final progress = ProgressTracker.getProgress(key);
          // Estimate cards learned (rough: progress * 20 cards per subsection)
          if (progress > 0) {
            total += (progress * 20).toInt();
          }
        }
      }
      _cardsLearned = total;
    });
  }

  // ========================================================================
  // SECTION 6: UI BUILD METHOD
  // ========================================================================
  
  @override
  Widget build(BuildContext context) {
    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),

                // ============================================================
                // SECTION 6.1: HEADER WITH BACK BUTTON
                // ============================================================
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
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ============================================================
                // SECTION 6.2: PROFILE CARD
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // ======================================================
                        // SECTION 6.2.1: USER AVATAR & NAME
                        // ======================================================
                        Row(
                          children: [
                            // Avatar with gradient background
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFFF8A80),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Name and email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // User name
                                  Text(
                                    widget.userName ?? 'Sarah Johnson',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // User email
                                  Text(
                                    widget.userEmail ?? 'sarah.j@email.com',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // ======================================================
                        // SECTION 6.2.2: STATISTICS DISPLAY
                        // ======================================================
                        // Shows bookmarks and cards learned
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Bookmarks stat
                            Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF2FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.bookmark,
                                    color: const Color(0xFF3B82F6),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_bookmarksCount',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Bookmarks',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            // Cards learned stat
                            Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E7FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    color: const Color(0xFFBB86FC),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_cardsLearned',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Cards\nLearned',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ============================================================
                // SECTION 6.3: LEARNING PROGRESS SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Learning Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Progress container with bars for each module
                      Container(
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
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: List.generate(
                            modules.length,
                            (index) {
                              final module = modules[index];
                              // Calculate average progress for this module
                              double progress = 0;
                              // Loop through subsections 1-2
                              for (int j = 1; j <= 2; j++) {
                                final key = '${module['number']}_$j';
                                // Get progress and average
                                progress +=
                                    ProgressTracker.getProgress(key) / 2;
                              }

                              // Convert to percentage (0-100)
                              final progressPercent =
                                  (progress * 100).toStringAsFixed(0);

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index < modules.length - 1 ? 16 : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // ========================================
                                    // Module title and percentage
                                    // ========================================
                                    Row(
                                      children: [
                                        // Module badge
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: module['color'],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'M${module['number']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Module name
                                        Expanded(
                                          child: Text(
                                            module['title'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2C3E50),
                                            ),
                                          ),
                                        ),
                                        // Progress percentage
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
                                    // ========================================
                                    // Progress bar
                                    // ========================================
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 6,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              module['color'],
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ============================================================
                // SECTION 6.4: ACCOUNT SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Log out button
                      GestureDetector(
                        onTap: () {
                          // Log out action would go here
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // Logout icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE8E8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: const Color(0xFFFF6B6B),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Log out text
                              const Expanded(
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFF6B6B),
                                  ),
                                ),
                              ),
                              // Chevron right
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}