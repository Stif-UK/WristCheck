import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/extract_methods.dart';

class AlternativeExports extends StatefulWidget {

  @override
  State<AlternativeExports> createState() => _AlternativeExportsState();
}

class _AlternativeExportsState extends State<AlternativeExports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alternative Exports"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Copy.getAlternativeExtractsCopy(),
            ),
            ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Generate Simple Extract"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.fileCsv),
                    )
                  ],
                ),
            onPressed: () async {
                  await ExtractMethods.generateSimpleExtract();
            }
              ,),
            const SizedBox(height: 20,),
            ElevatedButton(child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Generate Complex Extract"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.fileExport),
                )
              ],
            ),
              onPressed: () async {
              await ExtractMethods.generateComplexExtract();
              },
            )
          ],
        ),
      ),
    );
  }
}
