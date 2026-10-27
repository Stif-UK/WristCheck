import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/auth/auth_service.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/user/auth_gate.dart';
import 'package:wristcheck/ui/user/otp_page.dart';
import 'package:wristcheck/ui/user/update_password_page.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/controllers/sync_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  bool _isLoading = false;
  File? _localAvatar;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "profile_page");
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    // Check local disk first
    final file = await ImagesUtil.getLocalAvatar();
    if (file != null && mounted) {
      setState(() {
        _localAvatar = file;
      });
    }

    // Sync from cloud in the background
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Check user_metadata first
    String? remoteUrl = user.userMetadata?['avatar_url'];

    // Fallback: Check identities array for OAuth providers like Google
    if (remoteUrl == null && user.identities != null) {
      for (final identity in user.identities!) {
        final identityData = identity.identityData;
        if (identityData != null) {
          remoteUrl = identityData['avatar_url'] ?? identityData['picture'];
          if (remoteUrl != null && remoteUrl.toString().trim().isNotEmpty) {
            break;
          }
        }
      }
    }

    if (remoteUrl != null && remoteUrl.toString().trim().isNotEmpty) {
      final remoteUrlString = remoteUrl.toString().trim();
      
      // Since we are now using Signed URLs, the token changes every time we request it.
      // We need to compare just the base file path, not the exact signed URL token.
      final lastSavedUrl = WristCheckPreferences.getLastAvatarUrl();
      
      // Strip everything after the ? (the token/timestamp) to see if it's pointing to the same file
      final cleanRemoteUrl = remoteUrlString.split('?').first;
      final cleanLocalUrl = lastSavedUrl?.split('?').first;
      
      final existingFile = await ImagesUtil.getLocalAvatar();
      if (cleanLocalUrl == cleanRemoteUrl && existingFile != null) {
        return;
      }

      // If it's a new file or missing locally, we need to request a fresh signed URL to download it
      final userPath = Supabase.instance.client.auth.currentUser!.id;
      final freshSignedUrl = await Supabase.instance.client.storage.from('avatars').createSignedUrl('$userPath/avatar.jpg', 60);

      await ImagesUtil.syncAvatar(freshSignedUrl);
      final newFile = await ImagesUtil.getLocalAvatar();
      
      if (newFile != null && mounted) {
        // Evict the old file from Flutter's memory cache before setting state
        await FileImage(newFile).evict();
        setState(() {
          _localAvatar = newFile;
        });
      }
    }
  }

  void _handleUpdateAvatar() async {
    final imageSource = await ImagesUtil.imageSourcePopUp(context);
    if (imageSource == null) return;

    setState(() {
      _isLoading = true;
    });

    final image = await ImagesUtil.pickImage(source: imageSource);
    
    if (image != null) {
      // 1. Save it to local storage officially
      final directory = await getApplicationDocumentsDirectory();
      final avatarDir = Directory("${directory.path}/avatar");
      if (!await avatarDir.exists()) {
        await avatarDir.create();
      }
      final localFile = await image.copy("${avatarDir.path}/avatar.jpg");
      
      // Evict the old image from memory cache before updating UI
      await FileImage(localFile).evict();

      // 2. Instantly update UI with local crop
      setState(() {
        _localAvatar = localFile;
      });
      
      // 3. Upload to Supabase and get new URL
      final authService = AuthService();
      final newAvatarUrl = await authService.uploadAvatar(localFile);
      
      if (newAvatarUrl != null) {
        // 4. Update the Database user_metadata & Preferences
        await authService.updateAvatarUrl(newAvatarUrl);
        await WristCheckPreferences.setLastAvatarUrl(newAvatarUrl);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSignOut() {
    Get.defaultDialog(
      title: "Sign Out",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Sign Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        await analytics.logEvent(name: "sign_out");
        Get.back(); // close dialog
        
        setState(() {
          _isLoading = true;
        });
        
        // Ensure no pending OTP email leaks over to the next state
        AuthGate.pendingOtpEmail.value = null;
        
        // Wipe local avatar cache
        final file = await ImagesUtil.getLocalAvatar();
        if (file != null && await file.exists()) {
          await file.delete();
        }
        await WristCheckPreferences.setLastAvatarUrl("");
        
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
    final l = AppLocalizations.of(context)!;
    final name = AuthService().getUsersName() ?? "";
    final email = AuthService().getUserEmail() ?? '(no email found)';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Management"),
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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  backgroundImage: _localAvatar != null
                      ? FileImage(
                          _localAvatar!,
                          // This forces the ImageProvider to invalidate the cache when the UI updates
                          // We use the last modified timestamp to bust the internal memory cache
                          scale: 1.0,
                        )
                      : null,
                  child: _localAvatar == null
                    ? const Icon(Icons.account_circle, size: 120, color: Colors.grey)
                    : null,
                ),
                if (_isLoading)
                  const CircularProgressIndicator(),
              ],
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                child: const Text("Update Avatar"),
                onPressed: _isLoading ? null : _handleUpdateAvatar,
            ),
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
            // User Management Section
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                title: const Text("User Management"),
                children: [Column(
                  children: [
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
                ),]
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                initiallyExpanded: true,
                  title: Text(l.databaseSync),
              children: [
                Obx(() => Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const FaIcon(FontAwesomeIcons.cloud),
                      title: Text("${l.databaseSync}: ${SyncController.to.statusText}"),
                      subtitle: Text(SyncController.to.subtitleText),
                      trailing: SyncController.to.trailingIcon,
                    ))),
                Obx(() => SyncController.to.status.value == SyncStatusState.inProgress
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSyncPhaseRow(
                              context,
                              title: l.watchRecords,
                              progress: SyncController.to.watchProgress,
                              countText: "${SyncController.to.watchSynced.value}/${SyncController.to.watchTotal.value}",
                              isComplete: SyncController.to.isWatchComplete,
                            ),
                            const SizedBox(height: 12),
                            _buildSyncPhaseRow(
                              context,
                              title: l.accuracyRecords,
                              progress: SyncController.to.accuracyProgress,
                              countText: "${SyncController.to.accuracySynced.value}/${SyncController.to.accuracyTotal.value}",
                              isComplete: SyncController.to.isAccuracyComplete,
                            ),
                            const SizedBox(height: 12),
                            _buildSyncPhaseRow(
                              context,
                              title: l.watchImages,
                              progress: SyncController.to.imageProgress,
                              countText: "${SyncController.to.imageSynced.value}/${SyncController.to.imageTotal.value}",
                              isComplete: SyncController.to.isImageComplete,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink())
              ],),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                leading: const FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.redAccent),
                title: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Deleting your account will permanently remove all cloud data, synced watches, wear history, timing logs, and uploaded images.",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.trash, size: 16),
                          label: const Text("Delete Account", style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _isLoading ? null : _showDeleteAccountConfirmationDialog,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog() async {
    await analytics.logEvent(name: "delete_account_initiated");
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Your Account?"),
        content: const SingleChildScrollView(
          child: Text(
            "Are you sure you want to delete your WristTrack account?\n\n"
            "This action is permanent and cannot be undone:\n"
            "• Your cloud account and login details will be deleted.\n"
            "• All synced watches, wear history, timing logs, and uploaded images stored in the cloud will be permanently removed.\n"
            "• Local data currently on this device will remain intact unless you choose to reset the app.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(); // close confirmation dialog
              _showReAuthenticationDialog();
            },
            child: const Text("Delete Account"),
          ),
        ],
      ),
    );
  }

  void _showReAuthenticationDialog() {
    final hasPassword = AuthService().hasPassword();
    final passwordController = TextEditingController();
    bool isReAuthenticating = false;

    if (hasPassword) {
      Get.dialog(
        StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Re-authenticate"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Please enter your current password to confirm account deletion:"),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Current Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isReAuthenticating ? null : () => Get.back(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isReAuthenticating
                      ? null
                      : () async {
                          final password = passwordController.text.trim();
                          if (password.isEmpty) return;

                          setDialogState(() {
                            isReAuthenticating = true;
                          });

                          final userEmail = AuthService().getUserEmail();
                          if (userEmail == null) {
                            Get.back();
                            _showErrorSnackbar();
                            return;
                          }

                          final response = await AuthService().signInWithEmailAndPassword(userEmail, password);
                          if (response != null && response.user != null) {
                            Get.back(); // close re-auth dialog
                            _executeAccountDeletion();
                          } else {
                            setDialogState(() {
                              isReAuthenticating = false;
                            });
                          }
                        },
                  child: isReAuthenticating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Confirm & Delete"),
                ),
              ],
            );
          },
        ),
        barrierDismissible: false,
      );
    } else {
      Get.dialog(
        StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Re-authenticate"),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please re-authenticate with your sign-in provider to confirm account deletion."),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isReAuthenticating ? null : () => Get.back(),
                  child: const Text("Cancel"),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.google, size: 16),
                      label: const Text("Re-authenticate with Google"),
                      onPressed: isReAuthenticating
                          ? null
                          : () async {
                              setDialogState(() {
                                isReAuthenticating = true;
                              });
                              final res = await AuthService().signInWithGoogle();
                              if (res != null && res.user != null) {
                                Get.back();
                                _executeAccountDeletion();
                              } else {
                                setDialogState(() {
                                  isReAuthenticating = false;
                                });
                              }
                            },
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.apple, size: 16),
                        label: const Text("Re-authenticate with Apple"),
                        onPressed: isReAuthenticating
                            ? null
                            : () async {
                                setDialogState(() {
                                  isReAuthenticating = true;
                                });
                                final res = await AuthService().signInWithApple();
                                if (res != null && res.user != null) {
                                  Get.back();
                                  _executeAccountDeletion();
                                } else {
                                  setDialogState(() {
                                    isReAuthenticating = false;
                                  });
                                }
                              },
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  void _executeAccountDeletion() async {
    // Show loading spinner dialog
    Get.dialog(
      const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Deleting your cloud account and stored data...",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final success = await AuthService().deleteUserAccountAndCloudData();

    // Close loading dialog
    Get.back();

    if (success) {
      // Wipe local avatar cache
      final file = await ImagesUtil.getLocalAvatar();
      if (file != null && await file.exists()) {
        await file.delete();
      }
      await WristCheckPreferences.setLastAvatarUrl("");
      AuthGate.pendingOtpEmail.value = null;

      // Confirmation banner/toast
      Get.snackbar(
        "Account Deleted",
        "Your account and cloud data have been permanently deleted. WristTrack will now run in local-only mode.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );

      // Return to local mode / close ProfilePage
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      _showErrorSnackbar();
    }
  }

  void _showErrorSnackbar() {
    Get.snackbar(
      "Error",
      "Unable to delete account. Please check your internet connection and try again, or contact support@wristtrack.app.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }

  Widget _buildSyncPhaseRow(BuildContext context, {required String title, required double progress, required String countText, required bool isComplete}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Row(
              children: [
                Text(countText, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 6),
                if (isComplete)
                  const FaIcon(FontAwesomeIcons.check, size: 12, color: Colors.green)
                else
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
