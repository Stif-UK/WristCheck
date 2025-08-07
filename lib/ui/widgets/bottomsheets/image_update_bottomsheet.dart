import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/model/watches.dart';

class ImageUpdateBottomsheet extends StatelessWidget {
  ImageUpdateBottomsheet({super.key, required this.index, required this.watch});
  final int index;
  final Watches watch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.4,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header#


          Row(
            children: [
              Expanded(
                child: Text("${watch.toString()}\nImage ${index + 1}",
                  style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,),
              ),

            ],
          ),
          const SizedBox(height: 20,),
          ListTile(
            title: Text("Update Image"),
            trailing: Icon(FontAwesomeIcons.repeat, color: Colors.green,),
          ),
          const Divider(thickness: 2,),
          ListTile(
            title: Text("Delete Image"),
            trailing: Icon(FontAwesomeIcons.trash, color: Colors.red,),
          ),
          const Divider(thickness: 2,),
          ListTile(
            title: Text("Cancel"),
            onTap: ()=> Navigator.pop(context),
            trailing: Icon(FontAwesomeIcons.ban),
          )

        ],
      ),

    );
  }
}
