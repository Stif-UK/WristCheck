import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/sync/sync_service.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

enum ConflictChoice { keepBoth, prioritizeLocal, prioritizeCloud }

class ConflictItem {
  final Watches localWatch;
  final Watches remoteWatch;
  ConflictChoice choice = ConflictChoice.prioritizeCloud; // Default to prioritize cloud

  ConflictItem({required this.localWatch, required this.remoteWatch});
}

class ConflictResolutionDialog extends StatefulWidget {
  final List<ConflictItem> conflicts;
  final VoidCallback resolvedCallback;

  const ConflictResolutionDialog({
    super.key,
    required this.conflicts,
    required this.resolvedCallback,
  });

  @override
  State<ConflictResolutionDialog> createState() => _ConflictResolutionDialogState();
}

class _ConflictResolutionDialogState extends State<ConflictResolutionDialog> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late List<ConflictItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.conflicts;
    analytics.logScreenView(screenName: "conflict_resolution_dialog");
  }

  String _getLastWornString(Watches watch, AppLocalizations l) {
    if (watch.wearList.isEmpty) return l.neverWorn;
    final sorted = List<DateTime>.from(watch.wearList)..sort();
    return WristCheckFormatter.getFormattedDate(sorted.last);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.collectionConflictsTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.collectionConflictsMessage,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.localWatch.manufacturer} ${item.localWatch.model}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(l.localLastWorn(_getLastWornString(item.localWatch, l))),
                          Text(l.cloudLastWorn(_getLastWornString(item.remoteWatch, l))),
                          const SizedBox(height: 8),
                          DropdownButton<ConflictChoice>(
                            value: item.choice,
                            isDense: true,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: ConflictChoice.prioritizeCloud,
                                child: Text(l.prioritizeCloudDiscardLocal),
                              ),
                              DropdownMenuItem(
                                value: ConflictChoice.prioritizeLocal,
                                child: Text(l.prioritizeLocalOverwriteCloud),
                              ),
                              DropdownMenuItem(
                                value: ConflictChoice.keepBoth,
                                child: Text(l.keepBothAllowDuplicate),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  item.choice = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // close conflict dialog
            SyncService.checkForConflictsAndSync(); // return to high-level warning dialog
          },
          child: Text(l.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            await analytics.logEvent(name: "resolve_conflicts_applied");
            Get.back();
            widget.resolvedCallback();
          },
          child: Text(l.applyAndContinueSync),
        ),
      ],
    );
  }
}
