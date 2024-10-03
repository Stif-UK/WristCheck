import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:get/get.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key, required this.notesFieldController});

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController notesFieldController; 

  @override
  Widget build(BuildContext context) {
    return Obx(()=> WatchFormField(
          icon: const Icon(FontAwesomeIcons.noteSticky),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Notes:",
          hintText: "Notes",
          minLines: 4,
          maxLines: 150,
          controller: notesFieldController,
          textCapitalization: TextCapitalization.sentences,
        ),
    );
    }
  }
