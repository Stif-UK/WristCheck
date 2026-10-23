import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

enum SyncStatusState {
  upToDate,
  inProgress,
  waitingForConnection,
  syncFailure,
}

class SyncController extends GetxController {
  static SyncController get to => Get.find();

  final Rx<SyncStatusState> status = SyncStatusState.upToDate.obs;
  final Rx<DateTime?> lastSyncTime = Rx<DateTime?>(null);
  final RxString errorMessage = ''.obs;

  // Phase tracking
  final RxString currentPhase = 'none.obs'.obs; // 'watches', 'accuracy', 'images', 'done'

  final RxInt watchTotal = 0.obs;
  final RxInt watchSynced = 0.obs;

  final RxInt accuracyTotal = 0.obs;
  final RxInt accuracySynced = 0.obs;

  final RxInt imageTotal = 0.obs;
  final RxInt imageSynced = 0.obs;

  void setStatus(SyncStatusState newStatus, {String? error}) {
    status.value = newStatus;
    if (newStatus == SyncStatusState.upToDate || newStatus == SyncStatusState.syncFailure) {
      lastSyncTime.value = DateTime.now();
      currentPhase.value = 'done';
    }
    if (newStatus == SyncStatusState.upToDate) {
      watchSynced.value = watchTotal.value;
      accuracySynced.value = accuracyTotal.value;
      imageSynced.value = imageTotal.value;
    }
    if (error != null) {
      errorMessage.value = error;
    }
  }

  double get watchProgress => watchTotal.value == 0 ? 1.0 : (watchSynced.value / watchTotal.value).clamp(0.0, 1.0);
  double get accuracyProgress => accuracyTotal.value == 0 ? 1.0 : (accuracySynced.value / accuracyTotal.value).clamp(0.0, 1.0);
  double get imageProgress => imageTotal.value == 0 ? 1.0 : (imageSynced.value / imageTotal.value).clamp(0.0, 1.0);

  bool get isWatchComplete => watchTotal.value > 0 && watchSynced.value >= watchTotal.value;
  bool get isAccuracyComplete => accuracyTotal.value > 0 && accuracySynced.value >= accuracyTotal.value;
  bool get isImageComplete => imageTotal.value > 0 && imageSynced.value >= imageTotal.value;

  String get statusText {
    switch (status.value) {
      case SyncStatusState.upToDate:
        return "Up to date";
      case SyncStatusState.inProgress:
        return "In Progress";
      case SyncStatusState.waitingForConnection:
        return "Waiting for connection";
      case SyncStatusState.syncFailure:
        return "Sync Failure";
    }
  }

  Widget get trailingIcon {
    switch (status.value) {
      case SyncStatusState.upToDate:
        return const FaIcon(FontAwesomeIcons.check, color: Colors.green);
      case SyncStatusState.inProgress:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SyncStatusState.waitingForConnection:
        return const FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.orange);
      case SyncStatusState.syncFailure:
        return const FaIcon(FontAwesomeIcons.xmark, color: Colors.red);
    }
  }

  String get subtitleText {
    if (lastSyncTime.value == null) {
      return "Last Sync: Never";
    }
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(lastSyncTime.value!);
    return "Last Sync: $formattedTime";
  }
}
