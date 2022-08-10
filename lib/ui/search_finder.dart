import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/provider/db_provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/view_watch.dart';



class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key? key, required this.query}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return ValueListenableBuilder(
      valueListenable: Boxes.getWatches().listenable(),
      builder: (context, Box<Watches> watchBox, _) {
        ///* this is where we filter data
        var results = query.isEmpty
            ? watchBox.values.toList() // whole list
            : watchBox.values
            .where((c) => c.model.toLowerCase().contains(query) || c.manufacturer.toLowerCase().contains(query))
            .toList();

        return results.isEmpty
            ? Center(
          child: Text(
            'No results found !',
            // style: Theme.of(context).textTheme.headline6.copyWith(
            //   color: Colors.black,
            // ),
          ),
        )
            : ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            // passing as a custom list
            final Watches watchesListItem = results[index];

            return ListTile(
              onTap: () {
                ///* This is where we update index so that we could go to that screen
              //   var selectedWatchIndex =
              //   Provider.of<DatabaseProvider>(context, listen: false)
              //       .watchesBox
              //       .values
              //       .toList()
              //       .indexOf(results[index]);
              //   databaseProvider
              //       .updateSelectedIndex(selectedWatchIndex);
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ContactDetailsScreen()));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${watchesListItem.manufacturer} ${watchesListItem.model}",
                    textScaleFactor: 1.1,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    watchesListItem.status!,
                    textScaleFactor: 0.9,
                    style: TextStyle(fontStyle: FontStyle.italic),

                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}