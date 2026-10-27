import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/user/reset_password.dart';
import 'package:wristcheck/ui/user/signup_page.dart';
import 'package:wristcheck/ui/widgets/google_logo.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "login");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await analytics.logEvent(name: "login_attempted", parameters: {"method": "email"});
      await AuthService().signInWithEmailAndPassword(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.loginTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(thickness: 2,),
                ExpansionTile(
                  title: Text(l.whySignInTitle, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                  children: [Text(l.whySignInDescription)]
                ),
                const Divider(thickness: 2,),
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
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(()=>const ResetPassword());
                    },
                    child: Text(l.forgotPassword),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
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
                            l.loginButton,
                            style: const TextStyle(color: Colors.white, fontSize: 25),
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
                        l.orLoginWith,
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
                      icon: const GoogleLogo(size: 24),
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
                      icon: FaIcon(
                        FontAwesomeIcons.apple,
                        size: 24,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l.dontHaveAnAccount),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignupPage());
                    },
                    child: Text(l.signUp),
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
