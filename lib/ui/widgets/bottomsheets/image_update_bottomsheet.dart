import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

class ImageUpdateBottomsheet extends StatelessWidget {
  ImageUpdateBottomsheet({super.key, required this.index, required this.watch});
  final int index;
  final Watches watch;

  @override
  Widget build(BuildContext context) {
    int primaryIndex = watch.primaryImageIndex ?? 0;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        height: MediaQuery.of(context).size.height*0.6,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Header#
      
      
            Row(
              children: [
                Expanded(
                  //child: Text("${watch.toString()}\nImage ${index + 1}",
                   child: Text(AppLocalizations.of(context)!.imageBottomSheetTitle(index+1, watch.toString()),
                    style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,),
                ),
      
              ],
            ),
            const SizedBox(height: 20,),
            ListTile(
                title: Text(AppLocalizations.of(context)!.primaryImage),
                trailing: primaryIndex == index? Icon(FontAwesomeIcons.solidStar, color: Colors.blue,) : Icon(FontAwesomeIcons.star, color: Colors.blue,),
                onTap: () async {
                  Navigator.pop(context);
                  WatchMethods.setPrimaryImage(watch, index);
                }
            ),
            const Divider(thickness: 2,),
            ListTile(
              title: Text(AppLocalizations.of(context)!.updateImage),
              trailing: Icon(FontAwesomeIcons.repeat, color: Colors.green,),
              onTap: () async {
                Navigator.pop(context);
                await ImagesUtil.addImageViaController(index, context, watch);
              }
            ),
            const Divider(thickness: 2,),
            ListTile(
              title: Text(AppLocalizations.of(context)!.deleteImage),
              trailing: Icon(FontAwesomeIcons.trash, color: Colors.red,),
              onTap: ()=> WristCheckDialogs.showImageDeleteDialog(context, watch, index),
            ),
            const Divider(thickness: 2,),
            ListTile(
              title: Text(AppLocalizations.of(context)!.cancel),
              onTap: ()=> Navigator.pop(context),
              trailing: Icon(FontAwesomeIcons.ban),
            )
      
          ],
        ),
      
      ),
    );
  }
}
