import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background.dart';

// ============================================================================
// SECTION 1: LOGIN SCREEN WIDGET SETUP
// ============================================================================
// First screen users see. Allows existing users to sign in with email/password.
// After successful login, navigates to home screen.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ========================================================================
  // SECTION 2: FORM CONTROLLERS
  // ========================================================================
  // Text input controllers to manage user input
  
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // ========================================================================
  // SECTION 3: ANIMATION CONTROLLERS
  // ========================================================================
  // Controls the fade-in animation of the form container
  
  late AnimationController _containerController;
  late Animation<double> _containerOpacity;

  // ========================================================================
  // SECTION 4: UI STATE VARIABLES
  // ========================================================================
  
  // Whether password field is hidden or visible
  bool _obscurePassword = true;
  
  // Whether sign in button is currently processing
  bool _isSigningIn = false;

  // ========================================================================
  // SECTION 5: LIFECYCLE METHODS
  // ========================================================================
  
  @override
  void initState() {
    super.initState();
    // Initialize text controllers for form inputs
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Initialize animation controller for fade-in effect (800ms)
    _containerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create animation: fade in from 0.0 to 1.0
    _containerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _containerController, curve: Curves.easeOutCubic),
    );

    // Start the animation
    _containerController.forward();
  }

  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    _containerController.dispose();
    super.dispose();
  }

  // ========================================================================
  // SECTION 6: USER ACTION METHODS
  // ========================================================================
  
  /// Handle sign in button tap
  /// 
  /// Shows loading animation, then navigates to home after delay
  void _handleSignIn() {
    setState(() => _isSigningIn = true);
    
    // Simulate sign in delay (1.5 seconds)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isSigningIn = false);
        // Navigate to home screen
        context.go('/home');
      }
    });
  }

  // ========================================================================
  // SECTION 7: UI BUILD METHOD
  // ========================================================================
  
  @override
  Widget build(BuildContext context) {
    return GesturelyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  // ============================================================
                  // SECTION 7.1: APP LOGO
                  // ============================================================
                  Image.asset(
                    'assets/images/gesturelylogo.png',
                    width: 140,
                    height: 140,
                  ),

                  const SizedBox(height: 3),

                  // ============================================================
                  // SECTION 7.2: WELCOME TEXT
                  // ============================================================
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sign in to continue learning',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // ============================================================
                  // SECTION 7.3: ANIMATED FORM CONTAINER
                  // ============================================================
                  // Form fades in on screen load
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_containerController),
                    child: FadeTransition(
                      opacity: _containerOpacity,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ================================================
                            // SECTION 7.3.1: EMAIL INPUT FIELD
                            // ================================================
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey[500],
                                  size: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFF8904),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ================================================
                            // SECTION 7.3.2: PASSWORD INPUT FIELD
                            // ================================================
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outlined,
                                  color: Colors.grey[500],
                                  size: 18,
                                ),
                                // Visibility toggle button
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey[500],
                                    size: 18,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFF8904),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ================================================
                            // SECTION 7.3.3: FORGOT PASSWORD LINK
                            // ================================================
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ================================================
                            // SECTION 7.3.4: SIGN IN BUTTON
                            // ================================================
                            // Gradient button with loading indicator
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.5, 1.0],
                                  colors: [
                                    Color(0xFFFF8904),
                                    Color(0xFFFF637E),
                                    Color(0xFFFB64B6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF8904).withOpacity(0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _isSigningIn ? null : _handleSignIn,
                                  borderRadius: BorderRadius.circular(14),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Show spinner if loading
                                        if (_isSigningIn)
                                          SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white.withOpacity(
                                                      0.9,
                                                    ),
                                                  ),
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        else
                                          const Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        // Arrow icon next to text
                                        if (!_isSigningIn)
                                          const SizedBox(width: 8),
                                        if (!_isSigningIn)
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ============================================================
                  // SECTION 7.4: SIGN UP LINK
                  // ============================================================
                  // Navigates to signup screen if user doesn't have account
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.go('/signup');
                        },
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}