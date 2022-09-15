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
  bool _backupComplete = false;
  bool _loadedLocation = false;
  bool _loadedBackup = false;


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

                //Section 1: Select Backup Location - no other sections are displayed until a backup location is selected.
                const Text("Please Select Backup Location"),
                const SizedBox(height: 20,),

                //If Platform is Android give some guidance on backup location to minimise errors
                Platform.isAndroid? const Text("Backup location must be a sub-folder of the Android OS 'Documents' folder",
                    textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),) : const Text("We advise creating a new folder for backups, separate to the WristCheck app folder",
                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                ElevatedButton(
                    child: const Text("Select Backup Location"),
                    onPressed: () async {
                      await BackupRestoreMethods.pickBackupLocation().then((val) {
                        setState(() {
                          _backupLocation = val;
                        });
                      });
                    }, ),

                 //Only show icon if backup location is set, getSuccessIcon returns a loading spinner for a short time, then a tick
                _backupLocation == null? const SizedBox(height: 40,) : getSuccessIconLocation(_loadedLocation),

                const Divider(height: 15,
                  thickness: 2,),

                //Section 2: Backup. Only displays if the backup location is selected and the 'tick' icon has had time to load
                _backupLocation == null || _loadedLocation == false? const SizedBox(height: 20,): Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Backup Database",style: TextStyle(fontSize: 30,),),
                        ),
                        onPressed: () async {
                          setState(() {
                            _backupComplete = true;
                          });

                          Future.delayed(const Duration(seconds: 2),() async {
                            await BackupRestoreMethods.backupWatchBox(_backupLocation!).then((_){
                              setState((
                                  ) {
                                _loadedBackup = true;
                              });
                            }

                            ).onError((error, stackTrace) => WristCheckDialogs.getBackupFailedDialog(error.toString()));
                          } );


                          
                          
                        }, ),
                    ),
                    _backupComplete? getSuccessIconBackup(_loadedBackup): const SizedBox(height: 40,),
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

  Widget getSuccessIconLocation(bool loaded){
    Future.delayed(const Duration(seconds: 2), () {

        setState(() {
          _loadedLocation = true;
        });

    }
      );
    return loaded? const Icon(Icons.done, color: Colors.green,size: 40,): const CircularProgressIndicator();

  }

  Widget getSuccessIconBackup(bool loaded){
    // Future.delayed(const Duration(seconds: 2), () {
    //
    //   setState(() {
    //     _loadedBackup = true;
    //   });
    //
    // }
    // );
    return loaded? const Icon(Icons.done, color: Colors.green,size: 40,): const CircularProgressIndicator();

  }

}




