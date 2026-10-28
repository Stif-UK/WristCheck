import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
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

  List<String> _getIanaLocations() {
    final locations = tz.timeZoneDatabase.locations.keys.toList();
    locations.sort();
    return locations;
  }

  DateTime _calculateTime(DateTime referenceTime, WristTrackTimezone item) {
    if (item.timeZoneId != null && item.timeZoneId!.isNotEmpty) {
      try {
        final location = tz.getLocation(item.timeZoneId!);
        return tz.TZDateTime.now(location);
      } catch (_) {
        // Fallback to manual offset if location lookup fails
      }
    }
    final offsetMinutes = (item.offset * 60).round();
    return referenceTime.add(Duration(minutes: offsetMinutes));
  }

  String _getSubtitleText(WristTrackTimezone item) {
    if (item.timeZoneId != null && item.timeZoneId!.isNotEmpty) {
      try {
        final location = tz.getLocation(item.timeZoneId!);
        final nowInLoc = tz.TZDateTime.now(location);
        final tzAbbr = nowInLoc.timeZoneName;
        final offsetMinutes = nowInLoc.timeZoneOffset.inMinutes;
        final sign = offsetMinutes >= 0 ? '+' : '-';
        final absMins = offsetMinutes.abs();
        final h = absMins ~/ 60;
        final m = absMins % 60;
        final offsetStr = m == 0 ? '$sign${h}h' : '$sign$h:${m.toString().padLeft(2, "0")}h';
        return '$tzAbbr ($offsetStr) • ${item.timeZoneId}';
      } catch (_) {
        // Fallback to manual offset text
      }
    }
    return formatOffset(item.offset);
  }

  void _showTimezoneDialog(BuildContext context, [WristTrackTimezone? timezoneToEdit]) {
    final titleController = TextEditingController(text: timezoneToEdit?.title ?? '');
    double selectedOffset = timezoneToEdit?.offset ?? 0.0;
    String? selectedTimeZoneId = timezoneToEdit?.timeZoneId;
    bool isCityMode = timezoneToEdit == null ? true : (timezoneToEdit.timeZoneId != null && timezoneToEdit.timeZoneId!.isNotEmpty);

    final formKey = GlobalKey<FormState>();
    final allIanaLocations = _getIanaLocations();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(timezoneToEdit == null ? 'Add Timezone' : 'Edit Timezone'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('City Search'),
                              selected: isCityMode,
                              onSelected: (selected) {
                                if (selected) {
                                  setDialogState(() {
                                    isCityMode = true;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Manual Offset'),
                              selected: !isCityMode,
                              onSelected: (selected) {
                                if (selected) {
                                  setDialogState(() {
                                    isCityMode = false;
                                    selectedTimeZoneId = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title / Label',
                          hintText: 'e.g. Home, Office, New York',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (isCityMode) ...[
                        Autocomplete<String>(
                          initialValue: TextEditingValue(text: selectedTimeZoneId ?? ''),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            final query = textEditingValue.text.toLowerCase().replaceAll(' ', '_');
                            return allIanaLocations.where((location) {
                              return location.toLowerCase().contains(query);
                            }).take(20);
                          },
                          onSelected: (String selection) {
                            setDialogState(() {
                              selectedTimeZoneId = selection;
                              if (titleController.text.trim().isEmpty) {
                                final cityName = selection.split('/').last.replaceAll('_', ' ');
                                titleController.text = cityName;
                              }
                            });
                          },
                          fieldViewBuilder: (context, autocompleteController, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: autocompleteController,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelText: 'Search City / IANA Zone',
                                hintText: 'Type city (e.g. New York, London, Tokyo)',
                                prefixIcon: Icon(Icons.search),
                              ),
                              validator: (value) {
                                if (isCityMode && (selectedTimeZoneId == null || selectedTimeZoneId!.isEmpty)) {
                                  return 'Please select a city from the list';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        if (selectedTimeZoneId != null && selectedTimeZoneId!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Selected: $selectedTimeZoneId',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
                            ),
                          ),
                      ] else ...[
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
                    ],
                  ),
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
                      final timeZoneIdToSave = isCityMode ? selectedTimeZoneId : null;

                      if (timezoneToEdit != null) {
                        timezoneToEdit.title = title;
                        timezoneToEdit.offset = selectedOffset;
                        timezoneToEdit.timeZoneId = timeZoneIdToSave;
                        await timezoneToEdit.save();
                      } else {
                        final newTimezone = WristTrackTimezone(
                          title: title,
                          offset: selectedOffset,
                          timeZoneId: timeZoneIdToSave,
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
                        'Tap "Add Location" to search for a city or set a custom time offset.',
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
                    final tzItem = timezones[index];
                    final calculatedTime = _calculateTime(referenceTime, tzItem);
                    final formattedTime = WristCheckFormatter.getShortTime(calculatedTime, isMilitary);
                    final subtitleText = _getSubtitleText(tzItem);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: ListTile(
                        onTap: () => _showTimezoneDialog(context, tzItem),
                        title: Text(
                          tzItem.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        subtitle: Text(
                          subtitleText,
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
                              onPressed: () => _confirmDelete(context, tzItem),
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
