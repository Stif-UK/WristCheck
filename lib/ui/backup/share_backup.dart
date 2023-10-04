import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';

class ShareBackup extends StatefulWidget {
  const ShareBackup({Key? key}) : super(key: key);

  @override
  State<ShareBackup> createState() => _ShareBackupState();
}

class _ShareBackupState extends State<ShareBackup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Press the button below to create a copy of the app database (this can take a few seconds!). \n\nOnce created a 'share' pop-up should appear, allowing you to choose where to send the backup file.  ",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Backup Database",
                  style: Theme.of(context).textTheme.headlineSmall,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(FontAwesomeIcons.download),
                  )
                ],
              ),
              onPressed: (){
                BackupRestoreMethods.shareBackup();

              },
            ),
          ),
        ],
      ),
    );
  }
}
