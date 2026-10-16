import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/ui/user/auth_gate.dart';

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
    final email = AuthService().getUserEmail() ?? 'Unknown User';
    
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
            Text(
              email,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Data Sync Status: "),
                  subtitle: Text("Last Sync: 12:30 AM"),
                  trailing: FaIcon(FontAwesomeIcons.check, color: Colors.green,),
                )),
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.image),
                  title: Text("Image Sync Status: "),
                  subtitle: Text("Sync in progress"),
                  trailing: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )),
            const SizedBox(height: 15,),
            const Divider(thickness: 2,),
            const SizedBox(height: 15,),
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.envelope),
                title: Text("Update Email"),
            )),
            Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.lock),
                  title: Text("Change Password"),
                )),
          ],
        ),
      ),
    );
  }
}
