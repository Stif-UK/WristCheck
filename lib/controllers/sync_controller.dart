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

  void setStatus(SyncStatusState newStatus, {String? error}) {
    status.value = newStatus;
    if (newStatus == SyncStatusState.upToDate || newStatus == SyncStatusState.syncFailure) {
      lastSyncTime.value = DateTime.now();
    }
    if (error != null) {
      errorMessage.value = error;
    }
  }

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
