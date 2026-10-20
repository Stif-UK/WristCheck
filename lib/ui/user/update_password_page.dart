import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class UpdatePasswordPage extends StatefulWidget {
  final bool hasExistingPassword;

  const UpdatePasswordPage({super.key, required this.hasExistingPassword});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final oldPassword = widget.hasExistingPassword ? _currentPasswordController.text : null;
      final newPassword = _newPasswordController.text;

      final response = await AuthService().updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response != null && response.user != null) {
          Get.back(); // Go back to profile page
          Get.snackbar("Success", "Password successfully updated.",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hasExistingPassword ? 'Change Password' : 'Set Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.hasExistingPassword) ...[
                  WatchFormField(
                    fieldTitle: 'Current Password',
                    hintText: 'Enter current password',
                    icon: const FaIcon(FontAwesomeIcons.lockOpen),
                    controller: _currentPasswordController,
                    enabled: true,
                    maxLines: 1,
                    obscureText: true,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                ],
                WatchFormField(
                  fieldTitle: 'New Password',
                  hintText: 'Enter new password',
                  icon: const FaIcon(FontAwesomeIcons.lock),
                  controller: _newPasswordController,
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
                  fieldTitle: 'Verify Password',
                  hintText: 'Verify your new password',
                  icon: const FaIcon(FontAwesomeIcons.key),
                  controller: _verifyPasswordController,
                  enabled: true,
                  maxLines: 1,
                  obscureText: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please verify your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
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
                          widget.hasExistingPassword ? 'Update Password' : 'Set Password', 
                          style: const TextStyle(
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
