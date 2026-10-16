import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class ResetPasswordOtp extends StatefulWidget {
  final String email;

  const ResetPasswordOtp({super.key, required this.email});

  @override
  State<ResetPasswordOtp> createState() => _ResetPasswordOtpState();
}

class _ResetPasswordOtpState extends State<ResetPasswordOtp> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerifyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
    super.dispose();
  }

  void _confirmReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final token = _otpController.text.trim();
      final newPassword = _passwordController.text;

      final success = await AuthService().verifyRecoveryOtpAndSetPassword(
        widget.email,
        token,
        newPassword,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Navigating back should lead them towards AuthGate, which will detect the new session
          Get.until((route) => route.isFirst);
          Get.snackbar("Success", "Your password has been successfully reset.",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
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
                  'A 6-digit verification code has been sent to ${widget.email}. Enter it below along with your new password.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                WatchFormField(
                  fieldTitle: 'OTP Code',
                  hintText: 'Enter 6-digit code',
                  icon: const FaIcon(FontAwesomeIcons.key),
                  controller: _otpController,
                  enabled: true,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the OTP';
                    }
                    if (value.trim().length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                WatchFormField(
                  fieldTitle: 'New Password',
                  hintText: 'Enter new password',
                  icon: const FaIcon(FontAwesomeIcons.lock),
                  controller: _passwordController,
                  enabled: true,
                  maxLines: 1,
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
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
                  fieldTitle: 'Confirm New Password',
                  hintText: 'Verify your new password',
                  icon: const FaIcon(FontAwesomeIcons.lock),
                  controller: _passwordVerifyController,
                  enabled: true,
                  maxLines: 1,
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please verify your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmReset,
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
                      : const Text(
                          'Confirm', 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 25
                          )
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
