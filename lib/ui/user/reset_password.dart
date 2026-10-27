import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/user/reset_password_otp.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "reset_password");
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _requestReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      await AuthService().requestPasswordReset(email);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        final l = AppLocalizations.of(context)!;
        Get.defaultDialog(
          title: l.checkYourEmailTitle,
          middleText: l.checkYourEmailMessage(email),
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back(); // close the dialog
            Get.off(() => ResetPasswordOtp(email: email)); // Navigate to the OTP page
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.resetPasswordTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.resetPasswordDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24.0),
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
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestReset,
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
                            l.requestResetButton,
                            style: const TextStyle(color: Colors.white, fontSize: 25),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
