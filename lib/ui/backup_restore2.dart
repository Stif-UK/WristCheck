import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class BackupRestore2 extends StatefulWidget {
   BackupRestore2({Key? key}) : super(key: key);

  @override
  State<BackupRestore2> createState() => _BackupRestore2State();
}

class _BackupRestore2State extends State<BackupRestore2> {
  String lastBackup = "No backup recorded";

  String? backUpLocation;

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
      body: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(30),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Last Backup: $lastBackup", textAlign: TextAlign.start,),
            Row(
              children: [
                backUpLocation == null?
                const Text("Backup Location: Not Selected", textAlign: TextAlign.start,): const Text("Backup Location: Selected"),
                backUpLocation == null? const Icon(Icons.close,) : const Icon(Icons.done)
              ],
            ),
            ElevatedButton(
                child: const Text("Select Backup Location"),
                onPressed: (){
                  BackupRestoreMethods.pickBackupLocation().then((value) {
                    backUpLocation = value;
                    setState(() {});
                  }

                  );

                }, //onPressed
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30, 0, 0),
              child: ElevatedButton(
                child: const Text("Backup Database"),
                onPressed: () async {
                  if(backUpLocation == null) {
                    WristCheckDialogs.getBackupLocationNullDialog();
                  } else {
                    try {
                      await BackupRestoreMethods.backupWatchBox(backUpLocation!);

                          lastBackup = WristCheckFormatter.getFormattedDate(DateTime.now());
                          setState(() {});
                    } on Exception catch (e) {
                      WristCheckDialogs.getBackupFailedDialog();
                      print(e.toString());
                    }

                      // WristCheckDialogs.getBackupFailedDialog();

                    }
                }, ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30, 0, 0),
              child: ElevatedButton(
                child: const Text("Restore Database"),
                onPressed: () async {

                    await BackupRestoreMethods.restoreWatchBox();

                }, ),
            ),
          ],
        ),
      )
    );
  }
}
