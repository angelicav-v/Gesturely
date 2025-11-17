import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';
import 'flashcardscreen.dart' show BookmarksTracker;
import 'modulegridscreen.dart';
import 'profilescreen.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: BOOKMARKS SCREEN WIDGET SETUP
// ============================================================================
// Shows all bookmarked/saved flashcards that the user wants to review later.
// Users can remove bookmarks and tap to navigate to the card.

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  // ========================================================================
  // SECTION 2: UI BUILD METHOD
  // ========================================================================
  
  @override
  Widget build(BuildContext context) {
    // Get all bookmarked cards from global BookmarksTracker
    final bookmarkedCards = BookmarksTracker.getBookmarks();
    // Check if there are any bookmarks
    bool hasBookmarks = bookmarkedCards.isNotEmpty;

    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ================================================================
              // SECTION 2.1: TOP HEADER BAR
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
              // SECTION 2.2: MAIN CONTENT - BOOKMARKS OR EMPTY STATE
              // ================================================================
              Expanded(
                child: hasBookmarks
                    // ========================================================
                    // SECTION 2.2.1: BOOKMARKED CARDS LIST
                    // ========================================================
                    ? Column(
                        children: [
                          // Title
                          const Text(
                            'Bookmarked Flashcards',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // List of bookmark cards
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: bookmarkedCards.length,
                              itemBuilder: (context, index) {
                                final card = bookmarkedCards[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                                    child: Row(
                                      children: [
                                        // ========================================
                                        // Module Badge
                                        // ========================================
                                        // Shows module number with color
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: card['moduleColor'],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'M${card['moduleNumber']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // ========================================
                                        // Card Info
                                        // ========================================
                                        // Title, module name, subsection
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Card title
                                              Text(
                                                card['title'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2C3E50),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Module name
                                              Text(
                                                card['moduleName'],
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              // Subsection
                                              Text(
                                                card['subsection'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF9CA3AF),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // ========================================
                                        // Remove Bookmark Button
                                        // ========================================
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              BookmarksTracker.removeBookmark(
                                                card['moduleNumber'],
                                                card['subsectionNumber'],
                                                card['title'],
                                              );
                                            });
                                          },
                                          child: Icon(
                                            Icons.bookmark,
                                            color: const Color(0xFF2563EB),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    // ========================================================
                    // SECTION 2.2.2: EMPTY STATE
                    // ========================================================
                    // When no bookmarks exist
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bookmark outline icon
                          Icon(
                            Icons.bookmark_outline,
                            size: 80,
                            color: const Color(0xFFB0B8C1),
                          ),
                          const SizedBox(height: 20),
                          // Title
                          const Text(
                            'No Bookmarks Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          const Text(
                            'Your saved flashcards will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 20),

              // ================================================================
              // SECTION 2.3: BOTTOM NAVIGATION BAR
              // ================================================================
              // Three buttons: Home, Apps, Bookmarks (highlighted)
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
                    // Home button - navigate to home screen
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
                    // Apps button - navigate to modules grid
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
                    // Bookmarks button (highlighted - current screen)
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
                        Icons.bookmark,
                        color: Colors.white,
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