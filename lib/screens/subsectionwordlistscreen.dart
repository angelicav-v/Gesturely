import 'package:flutter/material.dart';
import '../widgets/background.dart';
import 'settingscreen.dart';

// ============================================================================
// SECTION 1: SUBSECTION WORDS LIST SCREEN WIDGET SETUP
// ============================================================================
// Displays all cards/words in a searchable list for a subsection.
// Users can search, filter, and tap to jump to specific card.
// This is an alternative navigation method to the carousel view.

class SubsectionWordsListScreen extends StatefulWidget {
  final int moduleNumber;
  final int subsectionNumber;
  final String subsectionTitle;
  final List<String> cards;

  const SubsectionWordsListScreen({
    super.key,
    required this.moduleNumber,
    required this.subsectionNumber,
    required this.subsectionTitle,
    required this.cards,
  });

  @override
  State<SubsectionWordsListScreen> createState() =>
      _SubsectionWordsListScreenState();
}

class _SubsectionWordsListScreenState extends State<SubsectionWordsListScreen> {
  // ========================================================================
  // SECTION 2: STATE VARIABLES
  // ========================================================================
  
  // Controller for search input
  late TextEditingController _searchController;
  
  // Filtered list of cards based on search query
  List<String> _filteredCards = [];

  // ========================================================================
  // SECTION 3: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Initialize search controller
    _searchController = TextEditingController();
    // Initially show all cards
    _filteredCards = widget.cards;
  }

  @override
  void dispose() {
    // Clean up controller
    _searchController.dispose();
    super.dispose();
  }

  // ========================================================================
  // SECTION 4: SEARCH & FILTER METHODS
  // ========================================================================
  
  /// Filter cards based on search query
  /// 
  /// Updates the display to show only cards matching the search text
  void _filterCards(String query) {
    setState(() {
      if (query.isEmpty) {
        // Show all cards if search is empty
        _filteredCards = widget.cards;
      } else {
        // Filter: only show cards containing search term (case-insensitive)
        _filteredCards = widget.cards
            .where((card) => card.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
              // SECTION 5.1: HEADER WITH BACK & SETTINGS
              // ================================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button with gradient
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
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
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    // Subsection title
                    Text(
                      widget.subsectionTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
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
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // ================================================================
              // SECTION 5.2: SEARCH BAR
              // ================================================================
              // Allows users to search/filter words
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
                  child: TextField(
                    controller: _searchController,
                    // Call filter function as user types
                    onChanged: _filterCards,
                    decoration: InputDecoration(
                      hintText: 'Search words or phrases...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // ================================================================
              // SECTION 5.3: WORDS LIST
              // ================================================================
              // Shows filtered cards in a scrollable list
              Expanded(
                child: _filteredCards.isEmpty
                    // ========================================================
                    // SECTION 5.3.1: EMPTY STATE
                    // ========================================================
                    // Show when no cards match the search
                    ? Center(
                        child: Text(
                          'No words found',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      )
                    // ========================================================
                    // SECTION 5.3.2: WORD LIST
                    // ========================================================
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredCards.length,
                        itemBuilder: (context, index) {
                          // Get the original index in widget.cards
                          final cardIndex =
                              widget.cards.indexOf(_filteredCards[index]);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              // Tap to navigate to this card in flashcard view
                              onTap: () {
                                Navigator.pop(context, cardIndex);
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
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ========================================
                                    // SECTION 5.3.2.1: CARD NUMBER & WORD
                                    // ========================================
                                    Row(
                                      children: [
                                        // Card number badge
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF69B4)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${cardIndex + 1}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFFF69B4),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Card word/text
                                        Text(
                                          _filteredCards[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // ========================================
                                    // SECTION 5.3.2.2: NAVIGATION CHEVRON
                                    // ========================================
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey[300],
                                      size: 24,
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
              // Three buttons: Layers, Menu (highlighted), Copy
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
                    // Layers icon - navigate back to subsections
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Future.microtask(() => Navigator.pop(context));
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
                    // Menu icon (highlighted - current screen)
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
                      child: Icon(Icons.menu, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 8),
                    // Copy icon - navigate back to subsections
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'toSubsections');
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