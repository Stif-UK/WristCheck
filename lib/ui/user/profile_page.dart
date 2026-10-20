import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/user/auth_gate.dart';
import 'package:wristcheck/ui/user/otp_page.dart';
import 'package:wristcheck/ui/user/update_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  void _handleSignOut() {
    Get.defaultDialog(
      title: "Sign Out",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Sign Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back(); // close dialog
        
        setState(() {
          _isLoading = true;
        });
        
        // Ensure no pending OTP email leaks over to the next state
        AuthGate.pendingOtpEmail.value = null;
        
        await AuthService().signOut();
        
        // Delay to allow the auth stream to broadcast the sign out
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthService().getUsersName() ?? "";
    final email = AuthService().getUserEmail() ?? '(no email found)';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
            icon: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Icon(Icons.logout),
            onPressed: _isLoading ? null : _handleSignOut,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "Signed in as",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            //Display the users name and email address
            Text(name, style: Theme.of(context).textTheme.titleMedium,),
            Text(
              email,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            // Card(
            //     elevation: 2,
            //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            //     child: ListTile(
            //       leading: FaIcon(FontAwesomeIcons.cloud),
            //       title: Text("Data Sync Status: "),
            //       subtitle: Text("Last Sync: 12:30 AM"),
            //       trailing: FaIcon(FontAwesomeIcons.check, color: Colors.green,),
            //     )),
            // Card(
            //     elevation: 2,
            //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            //     child: ListTile(
            //       leading: FaIcon(FontAwesomeIcons.image),
            //       title: Text("Image Sync Status: "),
            //       subtitle: Text("Sync in progress"),
            //       trailing: CircularProgressIndicator(
            //         strokeWidth: 3,
            //       ),
            //     )),
            const SizedBox(height: 15,),
            const Divider(thickness: 2,),
            const SizedBox(height: 15,),
            //Update Name
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.user),
                  title: const Text("Update Name"),
                  onTap: () {
                    final currentName = AuthService().getUsersName() ?? "";
                    final nameController = TextEditingController(text: currentName);
                    
                    Get.defaultDialog(
                      title: "Update Name",
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      textConfirm: "Save",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        Get.back(); // close the dialog
                        final success = await AuthService().updateUserName(nameController.text);
                        if (success && mounted) {
                          setState(() {}); // refresh the profile page UI to show new name
                        }
                      },
                    );
                  },
                )),
            //Update email
            Builder(
              builder: (context) {
                String? pendingEmail = WristCheckPreferences.getPendingEmailChangeEmail();
                DateTime? pendingTimestamp = WristCheckPreferences.getPendingEmailChangeTimestamp();
                bool hasActiveEmailChange = false;

                if (pendingEmail != null && pendingTimestamp != null) {
                  if (DateTime.now().difference(pendingTimestamp).inMinutes < 60) {
                    hasActiveEmailChange = true;
                  } else {
                    // Expired
                    WristCheckPreferences.setPendingEmailChange(null, null);
                    pendingEmail = null;
                  }
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const FaIcon(FontAwesomeIcons.envelope),
                    title: Text(hasActiveEmailChange ? "Complete email update" : "Update Email"),
                    onTap: () async {
                      if (hasActiveEmailChange) {
                        await Get.to(() => OtpPage(
                          email: pendingEmail!,
                          isEmailChange: true,
                          onCancel: () => Get.back(),
                        ));
                        if (mounted) setState(() {});
                        return;
                      }

                      final currentEmail = AuthService().getUserEmail() ?? "";
                      final emailController = TextEditingController(text: currentEmail);
                      
                      Get.defaultDialog(
                        title: "Update Email",
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Once changed you will receive a one-time passcode to the new address.",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: "New Email",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                              ),
                            ],
                          ),
                        ),
                        textConfirm: "Send",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          Get.back(); // close the dialog
                          final newEmail = emailController.text.trim();
                          if (newEmail.isEmpty || newEmail == currentEmail) return;
                          
                          setState(() {
                            _isLoading = true;
                          });
                          
                          final success = await AuthService().updateEmail(newEmail);
                          
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                            
                            if (success) {
                              await WristCheckPreferences.setPendingEmailChange(newEmail, DateTime.now());
                              await Get.to(() => OtpPage(
                                email: newEmail,
                                isEmailChange: true,
                                onCancel: () => Get.back(),
                              ));
                              if (mounted) setState(() {});
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.lock),
                  title: Text(AuthService().hasPassword() ? "Change Password" : "Set Password"),
                  onTap: () {
                    final authService = AuthService();
                    final hasPwd = authService.hasPassword();

                    if (hasPwd) {
                      Get.to(() => const UpdatePasswordPage(hasExistingPassword: true));
                    } else {
                      final email = authService.getUserEmail();
                      if (email == null || email.trim().isEmpty) {
                        Get.defaultDialog(
                          title: "Email Required",
                          middleText: "An email address is required to be set first.",
                          textConfirm: "OK",
                          confirmTextColor: Colors.white,
                          onConfirm: () => Get.back(),
                        );
                      } else {
                        Get.defaultDialog(
                          title: "Set Password",
                          middleText: "Password login is optional when using OAuth login, however setting it provides an alternative login route.",
                          textConfirm: "Proceed",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            Get.back();
                            Get.to(() => const UpdatePasswordPage(hasExistingPassword: false));
                          },
                        );
                      }
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
