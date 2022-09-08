import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';

class BackupRestore extends StatelessWidget {
  const BackupRestore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup / Restore"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                //ToDo: Update help information
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),
    );
  }
}
