import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  File? _backupFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restore Database"),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                //ToDo: Update help information
                WristCheckDialogs.getBackupHelpDialog();
              } )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          const Text("Please select backup file"),
          const SizedBox(height: 20,),
          ElevatedButton(
            child: const Text("Select Backup File"),
          onPressed: () async{
              await BackupRestoreMethods.pickBackupFile().then((value) {
                setState(() {
                  _backupFile = value;
                });

              });
          },
          ),
          const SizedBox(height: 20,),
          _backupFile != null? Text("File selected: $_backupFile. Ready to load"): const Text(""),
          const Divider(thickness: 2,),
          const SizedBox(height: 20,),
          _backupFile == null? const SizedBox(height: 20,): ElevatedButton(
              child: const Text("Restore from Backup"),
              onPressed: (){
                WristCheckDialogs.getConfirmRestoreDialog(_backupFile!);
              }
           ),
        ],
      ),
    );
  }
}
