import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/ui/uploads/uploads_validation.dart';

class UploadsLanding extends StatefulWidget {
  UploadsLanding({
    super.key,
    this.csvPickerOverride,
    this.templateShareOverride,
  });

  final uploadsController = Get.put(UploadsController());
  final Future<List<List<dynamic>>?> Function()? csvPickerOverride;
  final Future<void> Function()? templateShareOverride;

  @override
  State<UploadsLanding> createState() => _UploadsLandingState();
}

class _UploadsLandingState extends State<UploadsLanding> {
  Future<void> _pickAndParseCsv() async {
    if (widget.uploadsController.isLoading.value) return;

    widget.uploadsController.isLoading.value = true;
    try {
      final picker = widget.csvPickerOverride ?? UploadMethods.getCSVImport;
      final result = await picker();

      if (result == null) {
        return; // User cancelled picker
      }

      final ok = widget.uploadsController.loadParsedRows(result);
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.uploadsController.errorMessage.value ??
                    'The selected CSV file is empty or could not be read.',
              ),
            ),
          );
        }
        return;
      }

      Get.to(() => UploadsValidation());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to read CSV file: $e'),
          ),
        );
      }
    } finally {
      widget.uploadsController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final groupedSpecs = <String, List<CsvColumnSpec>>{};
    for (final spec in CsvColumnRegistry.specs) {
      groupedSpecs.putIfAbsent(spec.group, () => []).add(spec);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l?.dataImport ?? 'Data Import'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.fileCsv,
                            size: 28,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Import Watches & Wear Dates from CSV',
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload any CSV file with a header row. Columns can be in any order — '
                        'WristTrack automatically matches recognised column names and ignores extra columns.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      _buildBullet(
                        context,
                        icon: Icons.check_circle_outline,
                        text: 'Required columns: Manufacturer (or Make / Brand) and Model.',
                      ),
                      const SizedBox(height: 6),
                      _buildBullet(
                        context,
                        icon: Icons.calendar_today_outlined,
                        text: 'Wear dates: Add one row per wear date (matching WristTrack\'s Detailed Extract). '
                            'Rows with the same Manufacturer & Model are automatically grouped into one watch. '
                            'Multiple dates separated by ";" in one cell are also supported.',
                      ),
                      const SizedBox(height: 6),
                      _buildBullet(
                        context,
                        icon: Icons.merge_type,
                        text: 'Duplicates: Matching Make + Model watches are flagged so you can merge '
                            '(fill blank fields & append new wear dates) or create a new record.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final loading = widget.uploadsController.isLoading.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: loading ? null : _pickAndParseCsv,
                      icon: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const FaIcon(FontAwesomeIcons.fileImport, size: 18),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(loading ? 'Reading CSV...' : 'Select CSV File'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: loading
                          ? null
                          : () async {
                              if (widget.templateShareOverride != null) {
                                await widget.templateShareOverride!();
                              } else {
                                await UploadMethods.shareSampleTemplate();
                              }
                            },
                      icon: const FaIcon(FontAwesomeIcons.fileExport, size: 16),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Download Sample CSV Template'),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.view_column_outlined),
                  title: const Text('Recognised Column Titles & Formats'),
                  subtitle: Text('${CsvColumnRegistry.specs.length} supported fields'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dates work best in YYYY-MM-DD format (e.g. 2025-01-15), though DD/MM/YYYY and standard text dates are also parsed.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Highlighted fields with an info icon validate against fixed options — tap one to view accepted values.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final entry in groupedSpecs.entries) ...[
                            Text(
                              entry.key,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: entry.value.map((spec) {
                                if (spec.isEnumValidated) {
                                  return ActionChip(
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Tap to view accepted values',
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                                    side: BorderSide(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.55),
                                    ),
                                    avatar: Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    label: Text(
                                      spec.canonicalName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    onPressed: () => _showAcceptedValuesDialog(context, spec),
                                  );
                                }
                                return Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    spec.required
                                        ? '${spec.canonicalName} *'
                                        : spec.canonicalName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildAiPromptCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiPromptCard(BuildContext context) {
    final theme = Theme.of(context);
    final prompt = UploadMethods.generateAiAssistantPrompt();

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.auto_awesome_outlined),
        title: const Text('Prepare CSV with an AI Assistant'),
        subtitle: const Text('Copy a template prompt to convert an existing spreadsheet'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Have an existing spreadsheet in a different layout? Copy this prompt and paste it alongside your spreadsheet into an AI assistant to generate a WristTrack-ready CSV.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      prompt,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: prompt));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('AI prompt copied to clipboard'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy Prompt'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAcceptedValuesDialog(BuildContext context, CsvColumnSpec spec) {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.rule, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('${spec.canonicalName} Values')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (spec.validationNote != null) ...[
                  Text(
                    spec.validationNote!,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  'Accepted Values (case-insensitive):',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: spec.acceptedValues
                      .map(
                        (v) => Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(v, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                ),
                if (spec.valueAliases.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Also Accepted Shorthands:',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: spec.valueAliases
                        .map(
                          (v) => Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(v, style: const TextStyle(fontSize: 12)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBullet(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
