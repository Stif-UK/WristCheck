import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/more_menu/gallery.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(10.0);

    //TODO: Implement ad on this page

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: pagePadding,
          child: ListTile(
            title: Text("Gallery",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,),
            trailing: Icon(FontAwesomeIcons.images),
            onTap: ()=> Get.to(Gallery()),
          ),
        ),
        const Divider(thickness: 2,),

      ],
    );
  }
}
