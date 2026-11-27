import 'package:get/get.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/model/watches.dart';

class UploadsController extends GetxController {
  final isLoading = false.obs;
  final isCommitting = false.obs;
  final headerAnalysis = Rxn<HeaderAnalysisResult>();
  final candidates = <ImportWatchCandidate>[].obs;
  final rawRowCount = 0.obs;
  final errorMessage = RxnString();

  bool get hasValidHeader => headerAnalysis.value?.isValid ?? false;

  int get totalWatchCount => candidates.length;

  int get readyToImportCount => candidates.where((c) {
        final status = c.computedStatus;
        return c.included &&
            status != UploadStatusEnum.fail &&
            status != UploadStatusEnum.skipped;
      }).length;

  int get duplicateCount => candidates.where((c) => c.isDuplicate).length;

  int get warningCount =>
      candidates.where((c) => c.computedStatus == UploadStatusEnum.partialpass).length;

  int get failCount =>
      candidates.where((c) => c.computedStatus == UploadStatusEnum.fail).length;

  int get skippedCount =>
      candidates.where((c) => c.computedStatus == UploadStatusEnum.skipped).length;

  int get totalWearDatesCount =>
      candidates.fold<int>(0, (sum, c) => sum + c.wearDates.length);

  int get includedWearDatesCount => candidates
      .where((c) {
        final status = c.computedStatus;
        return c.included &&
            status != UploadStatusEnum.fail &&
            status != UploadStatusEnum.skipped;
      })
      .fold<int>(0, (sum, c) {
        if (c.isDuplicate &&
            (c.duplicateResolution == DuplicateResolution.mergeFillEmpty ||
                c.duplicateResolution == DuplicateResolution.mergeOverwrite)) {
          return sum + c.countNewWearDatesFor(c.selectedExistingWatch);
        }
        return sum + c.wearDates.length;
      });

  void reset() {
    headerAnalysis.value = null;
    candidates.clear();
    rawRowCount.value = 0;
    errorMessage.value = null;
    isLoading.value = false;
    isCommitting.value = false;
  }

  /// Processes parsed CSV rows once at load time (never during widget build).
  bool loadParsedRows(List<List<dynamic>> rows) {
    errorMessage.value = null;
    if (rows.isEmpty) {
      headerAnalysis.value = null;
      candidates.clear();
      rawRowCount.value = 0;
      errorMessage.value = 'The selected CSV file is empty.';
      return false;
    }

    final analysis = UploadMethods.analyzeHeader(rows.first);
    headerAnalysis.value = analysis;
    rawRowCount.value = rows.length > 1 ? rows.length - 1 : 0;

    if (!analysis.isValid) {
      candidates.clear();
      return true;
    }

    final parsedCandidates = UploadMethods.parseAndGroupRows(rows, analysis);
    candidates.assignAll(parsedCandidates);
    return true;
  }

  void toggleInclude(int index, bool included) {
    if (index < 0 || index >= candidates.length) return;
    candidates[index].included = included;
    candidates.refresh();
  }

  void setDuplicateResolution(
    int index,
    DuplicateResolution resolution, {
    Watches? targetWatch,
  }) {
    if (index < 0 || index >= candidates.length) return;
    final candidate = candidates[index];
    candidate.duplicateResolution = resolution;
    if (targetWatch != null) {
      candidate.selectedExistingWatch = targetWatch;
    }
    if (resolution == DuplicateResolution.skip) {
      candidate.included = false;
    } else if (!candidate.hasBlockingError) {
      candidate.included = true;
    }
    candidates.refresh();
  }

  void refreshCandidate(int index) {
    if (index < 0 || index >= candidates.length) return;
    UploadMethods.refreshCandidateValidation(candidates[index]);
    candidates.refresh();
  }

  Future<ImportCommitResult> commitImport({bool triggerSync = true}) async {
    isCommitting.value = true;
    try {
      return await UploadMethods.commitImport(
        candidates.toList(),
        triggerSync: triggerSync,
      );
    } finally {
      isCommitting.value = false;
    }
  }
}
