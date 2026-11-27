import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/ui/uploads/watch_validation.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class UploadsValidation extends StatefulWidget {
  UploadsValidation({
    super.key,
    this.triggerSyncOnCommit = true,
  });

  final uploadsController = Get.put(UploadsController());
  final bool triggerSyncOnCommit;

  @override
  State<UploadsValidation> createState() => _UploadsValidationState();
}

class _UploadsValidationState extends State<UploadsValidation> {
  Future<void> _handleCommit() async {
    final controller = widget.uploadsController;
    if (controller.isCommitting.value || controller.readyToImportCount == 0) {
      return;
    }

    final result = await controller.commitImport(
      triggerSync: widget.triggerSyncOnCommit,
    );

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 24),
              SizedBox(width: 10),
              Text('Import Complete'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New watches created: ${result.createdCount}'),
              Text('Existing watches merged: ${result.mergedCount}'),
              Text('Wear dates added: ${result.wearDatesAdded}'),
              if (result.wearDatesSkippedDuplicate > 0)
                Text('Duplicate wear dates ignored: ${result.wearDatesSkippedDuplicate}'),
              if (result.skippedCount > 0)
                Text('Watches skipped: ${result.skippedCount}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Pop UploadsValidation and return to UploadsLanding / DataLinks
                Get.back();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.uploadsController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Review'),
      ),
      body: Obx(() {
        final analysis = controller.headerAnalysis.value;
        if (analysis == null) {
          return const Center(
            child: Text('No CSV data loaded.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView(
                    padding: const EdgeInsets.all(12.0),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildHeaderAnalysisCard(context, analysis, controller),
                      const SizedBox(height: 8),
                      if (!analysis.isValid)
                        _buildMissingColumnsError(context, analysis)
                      else if (controller.candidates.isEmpty)
                        _buildNoRowsCard(context)
                      else ...[
                        _buildSummaryBanner(context, controller),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.candidates.length,
                          itemBuilder: (_, index) {
                            return _buildCandidateCard(
                              context,
                              controller,
                              controller.candidates[index],
                              index,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (analysis.isValid && controller.candidates.isNotEmpty)
              _buildBottomBar(context, controller),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderAnalysisCard(
    BuildContext context,
    HeaderAnalysisResult analysis,
    UploadsController controller,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        leading: analysis.isValid
            ? const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 28)
            : const FaIcon(FontAwesomeIcons.circleXmark, color: Colors.red, size: 28),
        title: Text(
          analysis.isValid
              ? 'Columns Detected (${analysis.matchedCount} of ${analysis.totalKnownCount})'
              : 'Required Columns Missing',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          '${controller.rawRowCount.value} CSV data row(s) • '
          '${analysis.unrecognizedHeaders.length} unrecognised column(s)',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (analysis.missingRequiredFields.isNotEmpty) ...[
                  Text(
                    'Missing Required Columns',
                    style: theme.textTheme.labelLarge?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: analysis.missingRequiredFields.map((key) {
                      final name = CsvColumnRegistry.specForKey(key)?.canonicalName ?? key.name;
                      return Chip(
                        backgroundColor: Colors.red.withValues(alpha: 0.15),
                        label: Text(name),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                if (analysis.matchedHeaderNames.isNotEmpty) ...[
                  Text(
                    'Matched Columns',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: analysis.matchedHeaderNames.entries.map((entry) {
                      final canonical =
                          CsvColumnRegistry.specForKey(entry.key)?.canonicalName ?? entry.key.name;
                      final label = entry.value.toLowerCase() == canonical.toLowerCase()
                          ? canonical
                          : '${entry.value} → $canonical';
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.check, size: 16, color: Colors.green),
                        label: Text(label, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
                if (analysis.unrecognizedHeaders.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Ignored / Unrecognised Columns',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: analysis.unrecognizedHeaders.map((header) {
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                        label: Text(header, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingColumnsError(BuildContext context, HeaderAnalysisResult analysis) {
    final missingNames = analysis.missingRequiredFields
        .map((k) => CsvColumnRegistry.specForKey(k)?.canonicalName ?? k.name)
        .join(', ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cannot identify watches in this file',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your CSV header must include columns for: $missingNames. '
              'Please update the header row in your CSV and try again.',
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Choose Another File'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoRowsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('No watch rows were found below the header row.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Choose Another File'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context, UploadsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            _summaryChip(
              icon: Icons.watch,
              label: '${controller.totalWatchCount} Watches',
            ),
            _summaryChip(
              icon: Icons.calendar_month,
              label: '${controller.totalWearDatesCount} Wear Dates',
            ),
            if (controller.duplicateCount > 0)
              _summaryChip(
                icon: Icons.content_copy,
                label: '${controller.duplicateCount} Duplicates',
                color: Colors.orange,
              ),
            if (controller.warningCount > 0)
              _summaryChip(
                icon: Icons.warning_amber_rounded,
                label: '${controller.warningCount} Warnings',
                color: Colors.amber,
              ),
            if (controller.failCount > 0)
              _summaryChip(
                icon: Icons.error_outline,
                label: '${controller.failCount} Invalid',
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildCandidateCard(
    BuildContext context,
    UploadsController controller,
    ImportWatchCandidate candidate,
    int index,
  ) {
    final status = candidate.computedStatus;
    final statusLabel = WristCheckFormatter.getUploadStatusText(status);
    final newWearCount = candidate.isDuplicate &&
            (candidate.duplicateResolution == DuplicateResolution.mergeFillEmpty ||
                candidate.duplicateResolution == DuplicateResolution.mergeOverwrite)
        ? candidate.countNewWearDatesFor(candidate.selectedExistingWatch)
        : candidate.wearDates.length;

    final subtitleParts = <String>[
      statusLabel,
      if (candidate.wearDates.isNotEmpty)
        candidate.isDuplicate &&
                (candidate.duplicateResolution == DuplicateResolution.mergeFillEmpty ||
                    candidate.duplicateResolution == DuplicateResolution.mergeOverwrite)
            ? '$newWearCount new of ${candidate.wearDates.length} wear date(s)'
            : '${candidate.wearDates.length} wear date(s)',
      if (candidate.hasWarnings)
        '${candidate.issues.where((i) => !i.isError).length + candidate.invalidWearDateValues.length} warning(s)',
      'CSV row(s): ${candidate.sourceRowNumbers.join(", ")}',
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            ListTile(
              leading: UploadMethods.getStatusIcon(status),
              title: Text(
                candidate.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(subtitleParts.join(' • ')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: candidate.included &&
                        candidate.duplicateResolution != DuplicateResolution.skip,
                    onChanged: candidate.hasBlockingError
                        ? null
                        : (checked) {
                            final next = checked ?? false;
                            if (candidate.isDuplicate &&
                                next &&
                                candidate.duplicateResolution == DuplicateResolution.skip) {
                              controller.setDuplicateResolution(
                                index,
                                DuplicateResolution.mergeFillEmpty,
                              );
                            } else {
                              controller.toggleInclude(index, next);
                            }
                          },
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => Get.to(() => WatchValidation(index: index)),
            ),
            if (candidate.isDuplicate && !candidate.hasBlockingError)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  children: [
                    const Icon(Icons.merge_type, size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<DuplicateResolution>(
                        isExpanded: true,
                        isDense: true,
                        value: candidate.included
                            ? candidate.duplicateResolution
                            : DuplicateResolution.skip,
                        items: const [
                          DropdownMenuItem(
                            value: DuplicateResolution.mergeFillEmpty,
                            child: Text('Merge: Fill blank fields & append wear dates'),
                          ),
                          DropdownMenuItem(
                            value: DuplicateResolution.mergeOverwrite,
                            child: Text('Merge: Overwrite fields & append wear dates'),
                          ),
                          DropdownMenuItem(
                            value: DuplicateResolution.createNew,
                            child: Text('Create new watch record'),
                          ),
                          DropdownMenuItem(
                            value: DuplicateResolution.skip,
                            child: Text('Skip this watch'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.setDuplicateResolution(index, value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, UploadsController controller) {
    final readyCount = controller.readyToImportCount;
    final wearCount = controller.includedWearDatesCount;
    final committing = controller.isCommitting.value;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$readyCount watch(es) selected',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$wearCount wear date(s) to import',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: readyCount == 0 || committing ? null : _handleCommit,
                  icon: committing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(committing ? 'Importing...' : 'Import Watches'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
