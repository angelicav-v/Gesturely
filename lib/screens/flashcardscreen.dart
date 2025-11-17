import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';
import '../widgets/video_player_widget.dart';
import 'subsectionwordlistscreen.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: GLOBAL STATE MANAGEMENT CLASSES
// ============================================================================
// These classes manage data that needs to be shared across multiple screens
// (Progress tracking and Bookmarks). They use static members so the data
// persists even when navigating between screens.

/// ProgressTracker - Manages user learning progress
/// 
/// Tracks how much of each subsection the user has completed.
/// Uses key format: 'moduleNumber_subsectionNumber' (e.g., '1_2')
/// Progress value: 0.0 (not started) to 1.0 (completed)
class ProgressTracker {
  static final Map<String, double> _progress = {};

  static void setProgress(String key, double progress) {
    _progress[key] = progress;
  }

  static double getProgress(String key) {
    return _progress[key] ?? 0.0;
  }

  static void clearProgress() {
    _progress.clear();
  }
}

/// BookmarksTracker - Manages bookmarked flashcards
/// 
/// Users can bookmark cards they want to review later.
/// Stores bookmark data with module, subsection, and card info.
class BookmarksTracker {
  static final List<Map<String, dynamic>> _bookmarks = [];

  static void addBookmark(
    int moduleNumber,
    int subsectionNumber,
    String cardTitle,
    String moduleName,
    int subsectionCardCount,
  ) {
    final bookmark = {
      'moduleNumber': moduleNumber,
      'subsectionNumber': subsectionNumber,
      'title': cardTitle,
      'moduleName': moduleName,
      'subsection': 'Subsection $subsectionNumber',
      'moduleColor': _getModuleColor(moduleNumber),
    };

    final exists = _bookmarks.any(
      (b) =>
          b['moduleNumber'] == moduleNumber &&
          b['subsectionNumber'] == subsectionNumber &&
          b['title'] == cardTitle,
    );

    if (!exists) {
      _bookmarks.add(bookmark);
    }
  }

  static void removeBookmark(
    int moduleNumber,
    int subsectionNumber,
    String cardTitle,
  ) {
    _bookmarks.removeWhere(
      (b) =>
          b['moduleNumber'] == moduleNumber &&
          b['subsectionNumber'] == subsectionNumber &&
          b['title'] == cardTitle,
    );
  }

  static List<Map<String, dynamic>> getBookmarks() {
    return _bookmarks;
  }

  static bool isBookmarked(
    int moduleNumber,
    int subsectionNumber,
    String cardTitle,
  ) {
    return _bookmarks.any(
      (b) =>
          b['moduleNumber'] == moduleNumber &&
          b['subsectionNumber'] == subsectionNumber &&
          b['title'] == cardTitle,
    );
  }

  /// Returns the module color for visual distinction
  static Color _getModuleColor(int moduleNumber) {
    switch (moduleNumber) {
      case 1:
        return const Color(0xFFFF69B4); // Pink
      case 2:
        return const Color(0xFF10B981); // Green
      case 3:
        return const Color(0xFFBB86FC); // Purple
      case 4:
        return const Color(0xFF00BCD4); // Cyan
      default:
        return const Color(0xFF2C3E50);
    }
  }
}

// ============================================================================
// SECTION 2: FLASHCARD SCREEN WIDGET SETUP
// ============================================================================
// This is the main screen that displays flashcards to the user.
// It's a StatefulWidget because it needs to track state like current card,
// whether it's flipped, animations, etc.

class FlashcardScreen extends StatefulWidget {
  // Screen parameters passed from navigation
  final int moduleNumber;
  final int subsectionNumber;
  final String subsectionTitle;
  final int cardCount;
  final List<String> cards;

  const FlashcardScreen({
    Key? key,
    required this.moduleNumber,
    required this.subsectionNumber,
    required this.subsectionTitle,
    required this.cardCount,
    this.cards = const [],
  }) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  // ========================================================================
  // SECTION 3: STATE VARIABLES
  // ========================================================================
  // These variables track the current state of the screen

  // Page controller - allows swiping between cards
  late PageController _pageController;
  
  // Animation controller - handles the 3D flip animation (600ms)
  late AnimationController _flipController;
  
  // Current card index being viewed (0-based)
  int _currentCard = 0;
  
  // Track the furthest card the user has seen (for progress tracking)
  int _maxCardViewed = 0;
  
  // Whether current card is flipped to show back
  bool _isFlipped = false;
  
  // Set of indices for bookmarked cards (using Set for fast lookup)
  Set<int> _bookmarkedCards = {};

  // Default card templates - used as fallback if no real data provided
  final List<Map<String, String>> _cardTemplates = [
    {'front': 'Hello', 'back': 'Hello'},
    {'front': 'Thank You', 'back': 'Thank You'},
    {'front': 'Sorry', 'back': 'Sorry'},
    {'front': 'Yes', 'back': 'Yes'},
    {'front': 'No', 'back': 'No'},
    {'front': 'Please', 'back': 'Please'},
    {'front': 'Goodbye', 'back': 'Goodbye'},
    {'front': 'Good Morning', 'back': 'Good Morning'},
    {'front': 'Good Night', 'back': 'Good Night'},
    {'front': 'How are you?', 'back': 'How are you?'},
  ];

  // List of flashcards with front/back and media type (video/image)
  late List<Map<String, String>> flashcards;

  // ========================================================================
  // SECTION 4: LIFECYCLE METHODS
  // ========================================================================
  // These methods run at specific points in the widget's life

  @override
  void initState() {
    super.initState();
    // Initialize page controller for card swiping
    _pageController = PageController();
    // Initialize animation controller for 3D flip (600ms duration)
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // Generate flashcard data from module/subsection info
    _generateFlashcards();
  }

  @override
  void dispose() {
    // Clean up controllers when widget is destroyed
    _pageController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  // ========================================================================
  // SECTION 5: DATA GENERATION METHODS
  // ========================================================================
  // These methods fetch and organize card data

  /// Generate flashcards from module and subsection data
  /// 
  /// This method:
  /// 1. Gets the card names for this module/subsection combination
  /// 2. Converts each card name to a flashcard object
  /// 3. Adds media info (video or image path) to each card
  void _generateFlashcards() {
    flashcards = [];
    List<String> cardsToUse = _getCardsByModuleAndSubsection();

    if (cardsToUse.isNotEmpty) {
      // Convert each card name to a full flashcard object with media
      for (final card in cardsToUse) {
        final mediaInfo = _getCardMedia(card);
        flashcards.add({
          'front': card,
          'back': card,
          'backType': mediaInfo['backType'], // 'video' or 'image'
          'backContent': mediaInfo['backContent'], // file path
        });
      }
    } else {
      // Fallback: use template cards if no data found
      for (int i = 0; i < widget.cardCount; i++) {
        final template = _cardTemplates[i % _cardTemplates.length];
        flashcards.add({
          'front': '${template['front']} ${(i ~/ _cardTemplates.length) + 1}',
          'back': '${template['back']} ${(i ~/ _cardTemplates.length) + 1}',
          'backType': 'video',
          'backContent': 'assets/videos/placeholder.mp4',
        });
      }
    }
  }

  /// Get all card names for a specific module and subsection
  /// 
  /// Returns a list of card front-text (e.g., ['Hello', 'Goodbye', ...])
  /// The data is organized by module number and subsection number
  List<String> _getCardsByModuleAndSubsection() {
    switch (widget.moduleNumber) {
      case 1:
        // Module 1: Greetings & Introductions
        if (widget.subsectionNumber == 1) {
          // Subsection 1: Common Phrases (15 cards)
          return [
            "I don't know",
            'Learn',
            "You're welcome",
            'Thank you',
            'Please',
            'Sorry',
            'Yes',
            'Why',
            'No',
            'Me too / Same',
            'Always',
            'Never',
            'Wrong / Mistake',
            'Idea',
            'Know',
          ];
        } else if (widget.subsectionNumber == 2) {
          // Subsection 2: Greetings & Introductions (9 cards)
          return [
            'Goodnight',
            'Goodmorning',
            'Nice to meet you',
            "What's up?",
            'What is your name?',
            'My name is',
            'Bye (pt.1)',
            'Bye (pt.2)',
            'Hello',
          ];
        }
        break;
      case 2:
        // Module 2: Directions
        if (widget.subsectionNumber == 1) {
          return ['Left', 'North', 'South', 'East', 'West', 'Right', 'Where'];
        }
        break;
      case 3:
        // Module 3: Alphabet & Numbers
        if (widget.subsectionNumber == 1) {
          return ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
        } else if (widget.subsectionNumber == 2) {
          return [
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
            'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
          ];
        }
        break;
      case 4:
        // Module 4: Emotions & People
        if (widget.subsectionNumber == 1) {
          return [
            'Surprised',
            'Hungry',
            'Tired',
            'Angry',
            'Worried',
            'Happy',
          ];
        } else if (widget.subsectionNumber == 2) {
          return [
            'Sister (pt.1)', 'Sister (pt.2)', 'Brother (pt.1)', 'Brother (pt.2)',
            'Mother', 'Father', 'Grandma (pt.1)', 'Grandma (pt.2)',
            'Grandpa (pt.1)', 'Grandpa (pt.2)', 'Girl (pt.1)', 'Girl (pt.2)',
            'Boy (pt.1)', 'Boy (pt.2)', 'Woman (pt.1)', 'Woman (pt.2)',
            'Man (pt.1)', 'Man (pt.2)',
          ];
        }
        break;
    }
    return [];
  }

  // ========================================================================
  // SECTION 6: MEDIA ROUTING METHODS
  // ========================================================================
  // These methods convert card names to file paths (videos or images)

  /// Convert card name to media file path
  /// 
  /// This determines if the card uses a video or image, then routes to
  /// the correct folder and converts the name to the correct filename.
  /// 
  /// Example conversions:
  /// - 'Hello' -> 'assets/videos/greetings/hello.mp4' (video)
  /// - 'Please' -> 'assets/images/please.png' (image)
  /// - 'A' -> 'assets/images/a.png' (image)
  Map<String, dynamic> _getCardMedia(String cardName) {
    // Define which cards use images instead of videos
    const imageCards = {
      // Common Phrases subsection
      'Please', 'Sorry', 'Idea', 'Know',
      // Greetings subsection
      'Bye (pt.1)', 'Bye (pt.2)',
      // Numbers 1-10
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
      // Alphabet A-Z
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
      // Module 4 - People subsection
      'Sister (pt.1)', 'Sister (pt.2)', 'Brother (pt.1)', 'Brother (pt.2)',
      'Mother', 'Father', 'Grandma (pt.1)', 'Grandma (pt.2)', 
      'Grandpa (pt.1)', 'Grandpa (pt.2)', 'Girl (pt.1)', 'Girl (pt.2)',
      'Boy (pt.1)', 'Boy (pt.2)', 'Woman (pt.1)', 'Woman (pt.2)',
      'Man (pt.1)', 'Man (pt.2)',
    };

    // CASE 1: Image card
    if (imageCards.contains(cardName)) {
      final imageName = cardName.toLowerCase().replaceAll(' ', '');
      return {
        'backType': 'image',
        'backContent': 'assets/images/$imageName.png',
      };
    } 
    // CASE 2: Video card
    else {
      final videoName = cardName.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
      
      // Determine which folder based on card name
      final greetingsCardNames = ['Goodnight', 'Goodmorning', 'Nice to meet you', "What's up?", 'What is your name?', 'My name is', 'Hello'];
      final directionsCardNames = ['Left', 'North', 'South', 'East', 'West', 'Right', 'Where'];
      final emotionsCardNames = ['Surprised', 'Hungry', 'Tired', 'Angry', 'Worried', 'Happy'];
      
      String folder = greetingsCardNames.contains(cardName) ? 'greetings' 
          : directionsCardNames.contains(cardName) ? 'directions'
          : emotionsCardNames.contains(cardName) ? 'emotions'
          : 'common_phrases';
      
      return {
        'backType': 'video',
        'backContent': 'assets/videos/$folder/$videoName.mp4',
      };
    }
  }

  // ========================================================================
  // SECTION 7: NAVIGATION & COMPLETION METHODS
  // ========================================================================
  // These methods handle user navigation and completion of subsections

  /// Get the next subsection after the current one
  /// 
  /// Returns subsection data if there is a next one, or null if this
  /// is the last subsection in the module
  Map<String, dynamic>? _getNextSubsection() {
    const subsectionsByModule = {
      1: [
        {
          'number': 1,
          'title': 'Common Phrases',
          'cardCount': 15,
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
          'cards': [
            'Goodnight', 'Goodmorning', 'Nice to meet you', "What's up?",
            'What is your name?', 'My name is', 'Bye (pt.1)', 'Bye (pt.2)',
            'Hello',
          ],
        },
      ],
      2: [
        {
          'number': 1,
          'title': 'Directions',
          'cardCount': 7,
          'cards': ['Left', 'North', 'South', 'East', 'West', 'Right', 'Where'],
        },
      ],
      3: [
        {
          'number': 1,
          'title': 'Numbers 1-10',
          'cardCount': 10,
          'cards': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
        },
        {
          'number': 2,
          'title': "ABC's",
          'cardCount': 26,
          'cards': [
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
            'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
          ],
        },
      ],
      4: [
        {
          'number': 1,
          'title': 'Emotions',
          'cardCount': 6,
          'cards': [
            'Surprised', 'Hungry', 'Tired', 'Angry', 'Worried', 'Happy'
          ],
        },
        {
          'number': 2,
          'title': 'People',
          'cardCount': 18,
          'cards': [
            'Sister (pt.1)', 'Sister (pt.2)', 'Brother (pt.1)', 'Brother (pt.2)',
            'Mother', 'Father', 'Grandma (pt.1)', 'Grandma (pt.2)',
            'Grandpa (pt.1)', 'Grandpa (pt.2)', 'Girl (pt.1)', 'Girl (pt.2)',
            'Boy (pt.1)', 'Boy (pt.2)', 'Woman (pt.1)', 'Woman (pt.2)',
            'Man (pt.1)', 'Man (pt.2)',
          ],
        },
      ],
    };

    final moduleSubsections = subsectionsByModule[widget.moduleNumber] ?? [];
    final currentIndex = moduleSubsections.indexWhere(
      (s) => s['number'] == widget.subsectionNumber,
    );

    if (currentIndex >= 0 && currentIndex < moduleSubsections.length - 1) {
      return moduleSubsections[currentIndex + 1];
    }

    return null;
  }

  /// Check if this is the last subsection in the module
  bool _isLastSubsection() {
    return _getNextSubsection() == null;
  }

  /// Show the completion dialog when user finishes all cards
  /// 
  /// Displays options to:
  /// - Redo the same set
  /// - Move to next subsection (if available)
  /// - Go back to subsections screen
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with star
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${widget.subsectionTitle} ',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Text('⭐', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Completion text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Section Completed ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text('✓', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Redo Set button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pageController.jumpToPage(0);
                        _maxCardViewed = 0;
                        _isFlipped = false;
                        _flipController.reset();
                        _bookmarkedCards.clear();
                        setState(() {});
                      },
                      child: const Text(
                        'Redo Set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Next Set button - only if not last subsection
                  if (!_isLastSubsection())
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final progressKey =
                              '${widget.moduleNumber}_${widget.subsectionNumber}';
                          ProgressTracker.setProgress(progressKey, 1.0);

                          final nextSubsection = _getNextSubsection();
                          if (nextSubsection != null) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.push(
                              '/flashcards',
                              extra: {
                                'moduleNumber': widget.moduleNumber,
                                'subsectionNumber': nextSubsection['number'],
                                'subsectionTitle': nextSubsection['title'],
                                'cardCount': nextSubsection['cardCount'],
                                'cards': nextSubsection['cards'] ?? [],
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Next Set',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                    ),
                  if (!_isLastSubsection()) const SizedBox(height: 12),
                  // Back button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final progressKey =
                            '${widget.moduleNumber}_${widget.subsectionNumber}';
                        ProgressTracker.setProgress(progressKey, 1.0);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '← Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========================================================================
  // SECTION 8: UI BUILD METHOD
  // ========================================================================
  // This is the main widget build method that constructs the UI

  @override
  Widget build(BuildContext context) {
    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ================================================================
              // SECTION 8.1: TOP HEADER BAR
              // ================================================================
              // Shows back button, title, and settings button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () {
                        final progressKey =
                            '${widget.moduleNumber}_${widget.subsectionNumber}';
                        final progress =
                            (_maxCardViewed + 1) / widget.cardCount;
                        ProgressTracker.setProgress(progressKey, progress);
                        Navigator.pop(context);
                      },
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
                    // Title
                    Expanded(
                      child: Text(
                        widget.subsectionTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Settings button
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
                          Icons.settings,
                          color: const Color(0xFF2C3E50),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // ================================================================
              // SECTION 8.2: CARD COUNTER & BOOKMARK BUTTON
              // ================================================================
              // Shows current card number and bookmark functionality
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bookmark button - toggles between bookmarked/unbookmarked
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (BookmarksTracker.isBookmarked(
                          widget.moduleNumber,
                          widget.subsectionNumber,
                          flashcards[_currentCard]['front'] ?? '',
                        )) {
                          BookmarksTracker.removeBookmark(
                            widget.moduleNumber,
                            widget.subsectionNumber,
                            flashcards[_currentCard]['front'] ?? '',
                          );
                          _bookmarkedCards.remove(_currentCard);
                        } else {
                          BookmarksTracker.addBookmark(
                            widget.moduleNumber,
                            widget.subsectionNumber,
                            flashcards[_currentCard]['front'] ?? '',
                            'Module ${widget.moduleNumber}',
                            widget.cardCount,
                          );
                          _bookmarkedCards.add(_currentCard);
                        }
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _bookmarkedCards.contains(_currentCard)
                            ? const Color(0xFF2563EB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: _bookmarkedCards.contains(_currentCard)
                            ? Colors.white
                            : Colors.grey[300],
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Card counter display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
                    child: Text(
                      '${_currentCard + 1}/${widget.cardCount}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // ================================================================
              // SECTION 8.3: FLASHCARD PAGEVIEW
              // ================================================================
              // The main card display with flip animation and video/image
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.hardEdge,
                  // Update state when page changes (swiping)
                  onPageChanged: (index) {
                    setState(() {
                      _currentCard = index;
                      if (index > _maxCardViewed) {
                        _maxCardViewed = index;
                      }
                      _isFlipped = false;
                      _flipController.reset();
                    });
                  },
                  itemCount: widget.cardCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        // Tap to flip card
                        onTap: () {
                          if (_isFlipped) {
                            _flipController.reverse();
                          } else {
                            _flipController.forward();
                          }
                          setState(() {
                            _isFlipped = !_isFlipped;
                          });
                        },
                        // Animated builder for 3D flip effect
                        child: AnimatedBuilder(
                          animation: _flipController,
                          builder: (context, child) {
                            // Calculate rotation angle (0 to π radians)
                            final angle = _flipController.value * 3.14159;
                            // Create 3D rotation matrix
                            final transform = Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // perspective
                              ..rotateY(angle); // rotate around Y axis

                            return Transform(
                              alignment: Alignment.center,
                              transform: transform,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 32,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // FRONT OF CARD (question side)
                                    if (_flipController.value < 0.5)
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              size: 40,
                                              color: Colors.grey[300],
                                            ),
                                            const SizedBox(height: 24),
                                            Text(
                                              flashcards[index]['front'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF2C3E50),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            const Text(
                                              'Tap to reveal',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF9CA3AF),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    // BACK OF CARD (answer side with video/image)
                                    else
                                      Expanded(
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(3.14159), // flip text too
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Spacer(),
                                              // VIDEO OR IMAGE DISPLAY
                                              if (flashcards[index]
                                                      ['backType'] ==
                                                  'video')
                                                Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                    child: VideoPlayerWidget(
                                                      videoPath:
                                                          flashcards[index]
                                                              ['backContent'] ??
                                                              '',
                                                    ),
                                                  ),
                                                )
                                              else
                                                Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                    child: Image.asset(
                                                      flashcards[index]
                                                          ['backContent'] ??
                                                          '',
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.image,
                                                              color: Colors
                                                                  .grey[300],
                                                              size: 40,
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            const Text(
                                                              'Image not found',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                  0xFF9CA3AF,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              const Spacer(),
                                              // TEXT DEFINITION AT BOTTOM
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 20,
                                                  vertical: 16,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    begin:
                                                        Alignment.centerLeft,
                                                    end:
                                                        Alignment.centerRight,
                                                    colors: [
                                                      Color(0xFFFF8904),
                                                      Color(0xFFFF637E),
                                                      Color(0xFFFB64B6),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    12,
                                                  ),
                                                ),
                                                child: Text(
                                                  '"${flashcards[index]['back'] ?? ''}"',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // ================================================================
              // SECTION 8.4: NAVIGATION & PROGRESS DOTS
              // ================================================================
              // Shows arrow buttons and progress indicator dots
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left arrow button
                    GestureDetector(
                      onTap: () {
                        if (_currentCard > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
                    // Progress dots - one for each card
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.cardCount,
                          (index) => Container(
                            width: index == _currentCard ? 12 : 3,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: index == _currentCard
                                  ? const Color(0xFF2C3E50)
                                  : const Color.fromARGB(255, 165, 159, 159),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Right arrow button
                    GestureDetector(
                      onTap: () {
                        if (_currentCard < widget.cardCount - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        } else if (_currentCard == widget.cardCount - 1) {
                          // Last card - show completion dialog
                          _showCompletionDialog();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // ================================================================
              // SECTION 8.5: BOTTOM NAVIGATION BAR
              // ================================================================
              // Three buttons: Layers (subsections), Menu (words list), Copy (flashcards)
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
                    // Layers icon - go back to subsections
                    GestureDetector(
                      onTap: () {
                        final progressKey =
                            '${widget.moduleNumber}_${widget.subsectionNumber}';
                        final progress =
                            (_maxCardViewed + 1) / widget.cardCount;
                        ProgressTracker.setProgress(progressKey, progress);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Icon(
                          Icons.layers,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Menu icon - show words list/search
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubsectionWordsListScreen(
                              moduleNumber: widget.moduleNumber,
                              subsectionNumber: widget.subsectionNumber,
                              subsectionTitle: widget.subsectionTitle,
                              cards: flashcards
                                  .map((c) => c['front'] as String)
                                  .toList(),
                            ),
                          ),
                        );
                        if (result == 'subsections') {
                          final progressKey =
                              '${widget.moduleNumber}_${widget.subsectionNumber}';
                          final progress =
                              (_maxCardViewed + 1) / widget.cardCount;
                          ProgressTracker.setProgress(progressKey, progress);
                          Navigator.pop(context);
                        } else if (result == 'toSubsections') {
                          final progressKey =
                              '${widget.moduleNumber}_${widget.subsectionNumber}';
                          final progress =
                              (_maxCardViewed + 1) / widget.cardCount;
                          ProgressTracker.setProgress(progressKey, progress);
                          Navigator.pop(context);
                        } else if (result != null && result is int) {
                          // Jump to selected card
                          _pageController.jumpToPage(result);
                          setState(() {
                            _currentCard = result;
                            _isFlipped = false;
                            _flipController.reset();
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Icon(
                          Icons.menu,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Copy icon - highlighted (current screen)
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
                      child:
                          Icon(Icons.copy, color: Colors.white, size: 24),
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