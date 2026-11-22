import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key, required this.notesFieldController});

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController notesFieldController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return Obx(
      () => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: WatchFormField(
            icon: const FaIcon(FontAwesomeIcons.noteSticky),
            enabled: watchViewController.inEditState.value,
            fieldTitle: l10n.notesRowTitle,
            hintText: l10n.notesRowHintText,
            minLines: 4,
            maxLines: 150,
            controller: notesFieldController,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ),
    );
  }
}
