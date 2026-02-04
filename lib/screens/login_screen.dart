import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/animated_login_button.dart';

import '../routes/app_routes.dart' hide AppRoutes;
import '../widgets/custom_text_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isSignUp = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Simulating a login/signup delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  void toggleAuthMode() {
    setState(() {
      isSignUp = !isSignUp;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo at the top
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.lock_outline,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // App title and subtitle
                    Text(
                      appName,
                      style: TextStyle(
                        fontSize: AppFontSize.heading,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isSignUp ? "Create your account" : "Welcome back",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          CustomTextField(
                            controller: _emailController,
                            label: "Email",
                            hint: "Enter your email",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password field
                          CustomTextField(
                            controller: _passwordController,
                            label: "Password",
                            hint: "Enter your password",
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() =>
                                    _obscurePassword = !_obscurePassword);
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (isSignUp && value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Forgot password link (only show on login)
                          if (!isSignUp)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 40),

                          // Animated gradient login button
                          AnimatedLoginButton(
                            label: isSignUp ? "Sign Up" : "Login",
                            isLoading: isLoading,
                            onPressed: handleLogin,
                          ),

                          const SizedBox(height: 20),

                          // Toggle between login and signup
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isSignUp
                                    ? "Already have an account? "
                                    : "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: toggleAuthMode,
                                child: Text(
                                  isSignUp ? "Login" : "Sign Up",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}