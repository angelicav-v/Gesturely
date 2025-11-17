import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';

// ============================================================================
// SECTION 1: LOADING SCREEN WIDGET SETUP
// ============================================================================
// Splash/loading screen shown when app starts.
// Displays animated logo and tagline, then auto-navigates to login after 4 seconds.
// This is the first screen users see when launching the app.

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  // ========================================================================
  // SECTION 2: ANIMATION CONTROLLERS & ANIMATIONS
  // ========================================================================
  // Multiple animation controllers for different visual effects
  
  // Controller for logo animation (scale and fade)
  late AnimationController _iconController;
  
  // Controller for text animation (opacity and slide)
  late AnimationController _textController;
  
  // Controller for loading indicator dots (pulse effect)
  late AnimationController _indicatorController;

  // ========================================================================
  // SECTION 2.1: ICON ANIMATIONS
  // ========================================================================
  // Logo scales up and fades in
  
  // Scale animation: logo grows from 0.5 to 1.0 with elastic effect
  late Animation<double> _iconScale;
  
  // Opacity animation: logo fades in from 0 to 1 (first 60% of timeline)
  late Animation<double> _iconOpacity;

  // ========================================================================
  // SECTION 2.2: TEXT ANIMATIONS
  // ========================================================================
  // "Gesturely" text and tagline fade and slide in
  
  // Opacity animation: text fades in from 20% to 100% of timeline
  late Animation<double> _textOpacity;
  
  // Slide animation: text slides up from below (0, 0.3) to (0, 0)
  late Animation<Offset> _textSlide;

  // ========================================================================
  // SECTION 3: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Set up all animations
    _setupAnimations();
    // Start 4-second timer before navigating to login
    _startAutoTransition();
  }

  @override
  void dispose() {
    // Clean up all animation controllers
    _iconController.dispose();
    _textController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  // ========================================================================
  // SECTION 4: ANIMATION SETUP METHODS
  // ========================================================================
  
  /// Setup all animations with their timings and curves
  /// 
  /// This method creates three separate animation sequences:
  /// 1. Icon animation (scale + fade) - 1200ms total
  /// 2. Text animation (fade + slide) - 1000ms, starts 300ms after icon
  /// 3. Indicator animation (repeating pulse) - 1500ms, infinite loop
  void _setupAnimations() {
    // ====================================================================
    // SECTION 4.1: ICON ANIMATION SETUP
    // ====================================================================
    // Logo scale and fade effect
    
    _iconController = AnimationController(
      // Total duration: 1200ms
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Scale animation: grows from 0.5 (small) to 1.0 (normal size)
    // Uses elasticOut curve for bouncy effect
    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    // Opacity animation: fades in from 0 to 1
    // Uses Interval(0.0, 0.6) so it's fully opaque by 60% of animation
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // ====================================================================
    // SECTION 4.2: TEXT ANIMATION SETUP
    // ====================================================================
    // "Gesturely" text and tagline fade and slide in
    
    _textController = AnimationController(
      // Total duration: 1000ms
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Opacity animation: fades in from 20% to 100% of timeline
    // Starts later than icon, creating staggered effect
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    // Slide animation: text slides up from (0, 0.3) to (0, 0)
    // Moves from below center to normal position
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // ====================================================================
    // SECTION 4.3: INDICATOR ANIMATION SETUP
    // ====================================================================
    // Loading dots pulse effect (repeating)
    
    _indicatorController = AnimationController(
      // Total duration: 1500ms per cycle
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(); // Repeat indefinitely

    // ====================================================================
    // SECTION 4.4: START ANIMATIONS IN SEQUENCE
    // ====================================================================
    
    // Start icon animation immediately
    _iconController.forward();
    
    // Start text animation 300ms later (staggered timing)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _textController.forward();
    });
  }

  // ========================================================================
  // SECTION 5: NAVIGATION METHODS
  // ========================================================================
  
  /// Auto-transition to login screen after 4 seconds
  /// 
  /// This creates the "splash screen" effect where the loading screen
  /// displays briefly, then automatically navigates to the login screen
  void _startAutoTransition() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Navigate to login screen using GoRouter
        context.go('/login');
      }
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
          child: Column(
            children: [
              // Spacing above content (top spacer)
              const Spacer(),

              // ================================================================
              // SECTION 6.1: CENTER CONTENT
              // ================================================================
              // Main loading screen content in the middle of screen
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ============================================================
                    // SECTION 6.1.1: ANIMATED LOGO
                    // ============================================================
                    // App logo with scale and fade effects
                    ScaleTransition(
                      // Logo grows from 0.5 to 1.0
                      scale: _iconScale,
                      child: FadeTransition(
                        // Logo fades in from 0 to 1
                        opacity: _iconOpacity,
                        child: Image.asset(
                          'assets/images/gesturelylogo.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // ============================================================
                    // SECTION 6.1.2: ANIMATED TEXT & TAGLINE
                    // ============================================================
                    // App name with gradient and tagline
                    SlideTransition(
                      // Text slides up from below
                      position: _textSlide,
                      child: FadeTransition(
                        // Text fades in
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            // ================================================
                            // App name with gradient effect
                            // ================================================
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const [0.0, 0.5, 1.0],
                                colors: [
                                  Color(0xFFFF8904),
                                  Color(0xFFFF637E),
                                  Color(0xFFFB64B6),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'Gesturely',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // ================================================
                            // Tagline text
                            // ================================================
                            const Text(
                              'Learn ASL with confidence',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5D6E7F),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ============================================================
                    // SECTION 6.1.3: LOADING INDICATOR DOTS
                    // ============================================================
                    // Three animated dots that pulse in sequence
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedBuilder(
                          animation: _indicatorController,
                          // Each dot has staggered animation
                          builder: (context, child) {
                            // Create scale animation for each dot
                            // Each dot starts at different time using Interval
                            final scale = Tween<double>(begin: 1.0, end: 1.2)
                                .animate(
                                  CurvedAnimation(
                                    parent: _indicatorController,
                                    // Interval creates staggered effect:
                                    // Dot 0: starts at 0%, duration 15%
                                    // Dot 1: starts at 15%, duration 15%
                                    // Dot 2: starts at 30%, duration 15%
                                    curve: Interval(
                                      index * 0.15,
                                      (index * 0.15) + 0.3,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                              ),
                              child: ScaleTransition(
                                // Each dot scales up and down
                                scale: scale,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // Semi-transparent dark color
                                    color: Color(0xFF2C3E50)
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Spacing below content (bottom spacer)
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATION TIMING BREAKDOWN:
// ============================================================================
//
// Timeline of what happens during 4 seconds:
//
// 0ms:     Icon animation starts (scale + fade)
// 300ms:   Text animation starts (fade + slide)
// 1000ms:  Text animation completes
// 1200ms:  Icon animation completes
// ~1500ms: Indicator dots loop once
// 3000ms:  Indicator dots loop twice
// 4000ms:  Screen auto-navigates to login
//
// This creates a polished loading experience where:
// 1. Logo bounces in with elastic effect
// 2. Text slides up and fades in (delayed for stagger)
// 3. Loading dots pulse continuously
// 4. After 4 seconds, screen transitions to login
//
// ============================================================================