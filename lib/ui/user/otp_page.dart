import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final VoidCallback onCancel;
  final bool isEmailChange;

  const OtpPage({
    super.key, 
    required this.email, 
    required this.onCancel,
    this.isEmailChange = false,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isResendActive = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _isResendActive = false;
      _countdown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isResendActive = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      if (widget.isEmailChange) {
        final success = await AuthService().verifyEmailChangeOtp(widget.email, _otpController.text.trim());
        if (success && mounted) {
          await WristCheckPreferences.setPendingEmailChange(null, null);
          widget.onCancel(); // Use the callback to pop back to ProfilePage
          Get.snackbar("Success", "Your email address has been successfully updated.", snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        final response = await AuthService().verifyOTP(widget.email, _otpController.text.trim());
        if (response != null && response.session != null) {
          // Success handled by AuthGate listening to stream
        }
      }
    }
  }

  void _resendOtp() async {
    if (!_isResendActive) return;
    await AuthService().resendOTP(
      widget.email,
      type: widget.isEmailChange ? OtpType.emailChange : OtpType.signup,
    );
    _startCountdown();
  }

  void _openMailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Fallback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open mail client')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
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
                  'A 6-digit verification code has been sent to ${widget.email}.',
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
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: _isResendActive ? _resendOtp : null,
                  child: Text(_isResendActive ? 'Resend OTP' : 'Resend OTP in $_countdown seconds'),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: OutlinedButton.icon(
                    onPressed: _openMailApp,
                    icon: const Icon(Icons.mail),
                    label: const Text('Open Mail Client'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
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
