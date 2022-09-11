import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';

class Backup extends StatefulWidget {
  const Backup({Key? key}) : super(key: key);

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  String? _backupLocation;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup Database"),
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
          Expanded(
            flex: 4,
            child: Column(

              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Please Select Backup Location"),
                Platform.isAndroid? const Text("(Backup location must be a sub-folder of the OS 'Documents' folder)") : const Text(""),
                ElevatedButton(
                    child: const Text("Select Backup Location"),
                    onPressed: () async {
                      await BackupRestoreMethods.pickBackupLocation().then((val) {
                        setState(() {
                          _backupLocation = val;
                        });
                      });
                    }, ),

                 //Only show icon if backup location is set
                _backupLocation == null? const SizedBox(height: 40,) : getSuccessIcon(_loaded),

                const Divider(height: 15,
                  thickness: 2,),
                _backupLocation == null || _loaded == false? SizedBox(height: 20,): Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Backup Database",style: TextStyle(fontSize: 30,),),
                        ),
                        onPressed: (){}, ),
                    ),
                    const Icon(Icons.done, color: Colors.green,size: 40,),
                    const Divider(height: 15,
                      thickness: 2,),
                  ],
                ),




              ],
            ),
          ),
          const Expanded(
              flex:4,
              child: Icon(Icons.file_download, size: 70,)),
        ],
      ),
    );
  }

  Widget getSuccessIcon(bool loaded){
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _loaded = true;

      });
    }
      );
    return loaded? const Icon(Icons.done, color: Colors.green,size: 40,): const CircularProgressIndicator();

  }

}




