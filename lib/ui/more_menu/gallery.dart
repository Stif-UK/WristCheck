import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/util/images_util.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Gallery"),
      ),
      body: FutureBuilder(

          builder: (ctx, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Center(
                  child: Text("${snapshot.error} occurred",
                  style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else if (snapshot.hasData){
                final data = snapshot.data as List<String>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text("Listview"),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length ,
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(
                              leading: const Icon(FontAwesomeIcons.image),
                              title: Text("Image path: ${data[index]}"),
                            );
                          }
                      )
                    ],
                  ),
                );
              };
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: ImagesUtil.getImages(), )
    );
  }
}

