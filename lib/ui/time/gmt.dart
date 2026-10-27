import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/wristtrack_timezone.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class GMT extends StatelessWidget {
  const GMT({super.key});

  static final List<double> availableOffsets = List<double>.generate(
    57,
    (index) => -12.0 + (index * 0.5),
  );

  static String formatOffset(double offset) {
    final sign = offset >= 0 ? '+' : '-';
    final absOffset = offset.abs();
    final hours = absOffset.floor();
    final minutes = ((absOffset - hours) * 60).round();
    if (minutes == 0) {
      return '$sign$hours ${hours == 1 ? "hour" : "hours"}';
    } else {
      final minutesStr = minutes.toString().padLeft(2, '0');
      return '$sign$hours:$minutesStr hours';
    }
  }

  DateTime _calculateTimeForOffset(DateTime referenceTime, double offset) {
    final offsetMinutes = (offset * 60).round();
    return referenceTime.add(Duration(minutes: offsetMinutes));
  }

  void _showTimezoneDialog(BuildContext context, [WristTrackTimezone? timezoneToEdit]) {
    final titleController = TextEditingController(text: timezoneToEdit?.title ?? '');
    double selectedOffset = timezoneToEdit?.offset ?? 0.0;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(timezoneToEdit == null ? 'Add Timezone' : 'Edit Timezone'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title / Location',
                        hintText: 'e.g. New York, Tokyo',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<double>(
                      initialValue: availableOffsets.contains(selectedOffset) ? selectedOffset : 0.0,
                      decoration: const InputDecoration(
                        labelText: 'Time Offset',
                      ),
                      items: availableOffsets.map((double offset) {
                        return DropdownMenuItem<double>(
                          value: offset,
                          child: Text(formatOffset(offset)),
                        );
                      }).toList(),
                      onChanged: (double? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedOffset = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final title = titleController.text.trim();
                      if (timezoneToEdit != null) {
                        timezoneToEdit.title = title;
                        timezoneToEdit.offset = selectedOffset;
                        await timezoneToEdit.save();
                      } else {
                        final newTimezone = WristTrackTimezone(
                          title: title,
                          offset: selectedOffset,
                        );
                        await Boxes.getTimezones().add(newTimezone);
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WristTrackTimezone timezone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timezone'),
        content: Text('Are you sure you want to delete "${timezone.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await timezone.delete();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeController = Get.find<TimeController>();

    return ValueListenableBuilder<Box<WristTrackTimezone>>(
      valueListenable: Boxes.getTimezones().listenable(),
      builder: (context, box, _) {
        final timezones = box.values.toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tracked Timezones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'add_timezone_fab',
                    onPressed: () => _showTimezoneDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Location'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (timezones.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.public_off,
                        size: 48,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No timezones added yet.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Location" to start tracking multiple timezones.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              Obx(() {
                final referenceTime = timeController.currentDateTime.value;
                final isMilitary = timeController.militaryTime.value;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: timezones.length,
                  itemBuilder: (context, index) {
                    final tz = timezones[index];
                    final calculatedTime = _calculateTimeForOffset(referenceTime, tz.offset);
                    final formattedTime = WristCheckFormatter.getShortTime(calculatedTime, isMilitary);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: ListTile(
                        onTap: () => _showTimezoneDialog(context, tz),
                        title: Text(
                          tz.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        subtitle: Text(
                          formatOffset(tz.offset),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formattedTime,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () => _confirmDelete(context, tz),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          ],
        );
      },
    );
  }
}
