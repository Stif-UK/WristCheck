import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/user/auth_gate.dart';
import 'package:wristcheck/ui/widgets/google_logo.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerifyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "signup_page");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
    super.dispose();
  }
  
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      await analytics.logEvent(name: "signup_attempted", parameters: {"method": "email"});
      final response = await AuthService().signUpWithEmailAndPassword(email, password);
      
      // If sign up was successful, but email verification is required, session will be null.
      if (response != null && response.session == null && response.user != null) {
        AuthGate.pendingOtpEmail.value = email;
        
        // Add a slight delay to ensure AuthGate updates its state fully before we pop
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.createAnAccount),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WatchFormField(
                  fieldTitle: l.emailLabel,
                  hintText: l.emailHint,
                  icon: const FaIcon(FontAwesomeIcons.user),
                  controller: _emailController,
                  enabled: true,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l.emailRequired;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                      return l.enterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                WatchFormField(
                  fieldTitle: l.passwordLabel,
                  hintText: l.passwordHint,
                  icon: const FaIcon(FontAwesomeIcons.lock),
                  controller: _passwordController,
                  enabled: true,
                  maxLines: 1,
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l.passwordRequired;
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    
                    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
                    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
                    bool hasDigits = value.contains(RegExp(r'[0-9]'));
                    bool hasSpecialCharacters = value.contains(RegExp(r'[^a-zA-Z0-9]'));
                    
                    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
                      return 'Must be a combination of upper case, lower case,\nnumbers and symbols';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                WatchFormField(
                  fieldTitle: l.verifyPasswordLabel,
                  hintText: l.verifyPasswordHint,
                  icon: const FaIcon(FontAwesomeIcons.key),
                  controller: _passwordVerifyController,
                  enabled: true,
                  maxLines: 1,
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l.verifyPasswordRequired;
                    }
                    if (value != _passwordController.text) {
                      return l.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          l.createAccountButton, 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          l.orSignUpWith,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await analytics.logEvent(name: "login_attempted", parameters: {"method": "google"});
                          await AuthService().signInWithGoogle();
                        },
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        icon: const GoogleLogo(size: 30),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await analytics.logEvent(name: "login_attempted", parameters: {"method": "apple"});
                          await AuthService().signInWithApple();
                        },
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        icon: FaIcon(
                          FontAwesomeIcons.apple,
                          size: 30,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
