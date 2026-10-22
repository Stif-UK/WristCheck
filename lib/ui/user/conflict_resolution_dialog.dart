import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late List<ConflictItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.conflicts;
  }

  String _getLastWornString(Watches watch) {
    if (watch.wearList.isEmpty) return "Never worn";
    final sorted = List<DateTime>.from(watch.wearList)..sort();
    return WristCheckFormatter.getFormattedDate(sorted.last);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Collection Conflicts Found"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We found watches on this device that match watches already saved in your cloud account. Please choose how to handle each potential duplicate:",
              style: TextStyle(fontSize: 13),
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
                          Text("Local: Last Worn: ${_getLastWornString(item.localWatch)}"),
                          Text("Cloud: Last Worn: ${_getLastWornString(item.remoteWatch)}"),
                          const SizedBox(height: 8),
                          DropdownButton<ConflictChoice>(
                            value: item.choice,
                            isDense: true,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: ConflictChoice.prioritizeCloud,
                                child: Text("Prioritize Cloud (Discard Local)"),
                              ),
                              DropdownMenuItem(
                                value: ConflictChoice.prioritizeLocal,
                                child: Text("Prioritize Local (Overwrite Cloud)"),
                              ),
                              DropdownMenuItem(
                                value: ConflictChoice.keepBoth,
                                child: Text("Keep Both (Allow Duplicate)"),
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
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            widget.resolvedCallback();
          },
          child: const Text("Apply & Continue Sync"),
        ),
      ],
    );
  }
}
