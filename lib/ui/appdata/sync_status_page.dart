import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/sync_controller.dart';
import 'package:wristcheck/sync/sync_service.dart';

enum SyncStatusType {
  upToDate,
  unsyncedChanges,
  syncing,
  syncFailure,
  notSignedIn,
}

class SyncStatusItem {
  final IconData iconData;
  final Color iconColor;
  final String title;
  final String description;
  final SyncStatusType type;

  const SyncStatusItem({
    required this.iconData,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.type,
  });

  static SyncStatusItem getCurrentStatus() {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final isSyncing = Get.isRegistered<SyncController>() &&
        SyncController.to.status.value == SyncStatusState.inProgress;
    final isFailure = Get.isRegistered<SyncController>() &&
        SyncController.to.status.value == SyncStatusState.syncFailure;
    final anyDirty = Boxes.getWatches().values.any((w) => w.isDirty == true);

    if (!isLoggedIn) {
      return const SyncStatusItem(
        iconData: Icons.cloud_off,
        iconColor: Colors.grey,
        title: "Not signed in",
        description: "You are not signed in to a cloud account, so cloud sync is inactive.",
        type: SyncStatusType.notSignedIn,
      );
    } else if (isSyncing) {
      return const SyncStatusItem(
        iconData: Icons.cloud_sync,
        iconColor: Colors.blue,
        title: "Syncing...",
        description: "Cloud data synchronization is currently in progress.",
        type: SyncStatusType.syncing,
      );
    } else if (isFailure) {
      return const SyncStatusItem(
        iconData: Icons.cloud_off,
        iconColor: Colors.red,
        title: "Sync failed",
        description: "The last sync attempt encountered an error or connection issue.",
        type: SyncStatusType.syncFailure,
      );
    } else if (anyDirty) {
      return const SyncStatusItem(
        iconData: Icons.cloud_upload,
        iconColor: Colors.orange,
        title: "Unsynced changes",
        description: "You have local changes saved on your device waiting to be uploaded to the cloud.",
        type: SyncStatusType.unsyncedChanges,
      );
    } else {
      return const SyncStatusItem(
        iconData: Icons.cloud_done,
        iconColor: Colors.green,
        title: "Up to date",
        description: "All local changes are fully synchronized with the cloud.",
        type: SyncStatusType.upToDate,
      );
    }
  }

  static List<SyncStatusItem> getAllStatuses() {
    return const [
      SyncStatusItem(
        iconData: Icons.cloud_done,
        iconColor: Colors.green,
        title: "Up to date",
        description: "All local changes are fully synchronized with the cloud.",
        type: SyncStatusType.upToDate,
      ),
      SyncStatusItem(
        iconData: Icons.cloud_upload,
        iconColor: Colors.orange,
        title: "Unsynced changes",
        description: "You have local changes saved on your device waiting to be uploaded to the cloud.",
        type: SyncStatusType.unsyncedChanges,
      ),
      SyncStatusItem(
        iconData: Icons.cloud_sync,
        iconColor: Colors.blue,
        title: "Syncing...",
        description: "Cloud data synchronization is currently in progress.",
        type: SyncStatusType.syncing,
      ),
      SyncStatusItem(
        iconData: Icons.cloud_off,
        iconColor: Colors.red,
        title: "Sync failed",
        description: "The last sync attempt encountered an error or connection issue.",
        type: SyncStatusType.syncFailure,
      ),
      SyncStatusItem(
        iconData: Icons.cloud_off,
        iconColor: Colors.grey,
        title: "Not signed in",
        description: "You are not signed in to a cloud account, so cloud sync is inactive.",
        type: SyncStatusType.notSignedIn,
      ),
    ];
  }
}

class SyncStatusPage extends StatelessWidget {
  const SyncStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allStatuses = SyncStatusItem.getAllStatuses();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sync Status"),
      ),
      body: Obx(() {
        final current = SyncStatusItem.getCurrentStatus();

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(current.iconData, color: current.iconColor, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Status: ${current.title}",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              current.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Status Legend",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...allStatuses.map((item) {
              final isCurrent = item.type == current.type;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.iconData, color: item.iconColor, size: 28),
                    title: Row(
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: const Text(
                              'Active',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            backgroundColor: item.iconColor,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(item.description),
                    trailing: isCurrent
                        ? Icon(Icons.check_circle, color: item.iconColor, size: 24)
                        : null,
                  ),
                  const Divider(thickness: 1),
                ],
              );
            }).toList(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
        final isSyncing = Get.isRegistered<SyncController>() &&
            SyncController.to.status.value == SyncStatusState.inProgress;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: isSyncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync),
                label: Text(
                  !isLoggedIn
                      ? "Sync Now (Not Signed In)"
                      : isSyncing
                          ? "Syncing..."
                          : "Sync Now",
                ),
                onPressed: (isLoggedIn && !isSyncing)
                    ? () => SyncService.syncData()
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
