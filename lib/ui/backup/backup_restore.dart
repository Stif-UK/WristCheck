import 'package:flutter/material.dart';
import 'package:wristcheck/ui/backup/backup.dart';
import 'package:get/get.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/backup/restore.dart';

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

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width)*0.8,
              height: (MediaQuery.of(context).size.height)*0.15,
              child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Backup",
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                  ),
                  onPressed: (){
                    Get.to(() => const Backup());
                    },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: Colors.black)
                          )

                      )
                  )
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width)*0.8,
              height: (MediaQuery.of(context).size.height)*0.15,
              child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Restore",
                      style: TextStyle(
                        fontSize: 30,
                      ),),
                  ),
                  onPressed: (){
                    Get.to(() => const Restore());
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: Colors.black)
                          )

                      )
                  )
              ),
            ),
          ),
        ],
      ),

    );
  }
}
