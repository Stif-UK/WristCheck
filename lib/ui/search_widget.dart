import 'package:flutter/material.dart';
import 'package:wristcheck/ui/search_finder.dart';

class SearchWidget extends SearchDelegate{

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        //ToDo: Should this be updated to use Get routing for consistency
        close(context, null); // for closing the search page and going back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }


}