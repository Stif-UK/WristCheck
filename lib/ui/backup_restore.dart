import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';

class BackupRestore extends StatefulWidget {
   BackupRestore({Key? key}) : super(key: key);

  @override
  State<BackupRestore> createState() => _BackupRestoreState();
}

class _BackupRestoreState extends State<BackupRestore> {
  String lastBackup = "No backup recorded";

  String? backUpLocation = "Not Selected";

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.10,
                width: MediaQuery.of(context).size.width,
                child: Text("Last Backup: $lastBackup", textAlign: TextAlign.center,)),
            SizedBox(
                height: MediaQuery.of(context).size.height*0.15,
                width: MediaQuery.of(context).size.width,
                child: Text("Backup Location: $backUpLocation", textAlign: TextAlign.center,)),
            ElevatedButton(
                child: const Text("Backup Database"),
                onPressed: (){
                  setState(() {
                    BackupRestoreMethods.pickBackupLocation().then((value) => backUpLocation = value);
                  });

                }, //onPressed
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30, 0, 0),
              child: ElevatedButton(
                child: const Text("Restore Database"),
                onPressed: (){}, ),
            ),
          ],
        ),
      )
    );
  }
}
