import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

class ReviewPage extends StatelessWidget {
  final Color colour;
  final Watches? watch;
  final String title;
  final String subtitle1;
  final String? subtitleBig1;
  final String? subtitle2;
  final String? subtitleBig2;
  final String? subtitle3;
  final String? subtitleBig3;
  final String? subtitle4;

  ReviewPage({
    required Color this.colour, //Background colour for the page
    Watches? this.watch, //A watch - utilise with getImage Future
    required String this.title, //
    required String this.subtitle1,
    String? this.subtitleBig1,
    String? this.subtitle2,
    String? this.subtitleBig2,
    String? this.subtitle3,
    String? this.subtitleBig3,
    String? this.subtitle4,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: colour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: WristCheckConfig.getWCColour(),
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 24,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                  subtitle1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
            subtitleBig1 != null? Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  subtitleBig1!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
              ),
            ) : const SizedBox(height: 0,),
            //If we have an image, use a Futurebuilder to return it
            watch != null?
            FutureBuilder(
                future: ImagesUtil.getImage(watch!, true),
                builder: (context, snapshot) {
                  //start
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return const CircularProgressIndicator();
                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      final data = snapshot.data as File;
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(125.0),
                          child: Image.file(data, width: 250,),
                        ),
                      );
                    }
                  }
                  return _getEmptyIcon(context);
                } //builder
            ) : const SizedBox(height: 0,),
            subtitle2 != null? Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  subtitle2!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),
            ) : const SizedBox(height: 0,),
            subtitleBig2 != null? Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  subtitleBig2!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
              ),
            ) : const SizedBox(height: 0,),
            subtitle3 != null? Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  subtitle3!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),
            ) : const SizedBox(height: 0,),
            subtitleBig3 != null? Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  subtitleBig3!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
              ),
            ) : const SizedBox(height: 0,),
            subtitle4 != null? Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  subtitle4!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),
            ) : const SizedBox(height: 0,),
          ],
        ),
      ),
    );
  }

  }

Widget _getEmptyIcon(context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(125.0),
    child: Image.asset('assets/icon/drawerheader.png', width: 200,),
  );
}
