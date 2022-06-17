import 'place_service.dart';
import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  late PlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion('null', 'null'));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Scaffold();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        // We will put the api call here
        future: query == ""
            ? null
            : apiClient.fetchSuggestions(
                query, Localizations.localeOf(context).languageCode),
        builder: (context, snapshot) => query == ''
            ? Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text('Enter your address'),
              )
            : fetchIt(snapshot));
  }

  fetchIt(snapshot) {
    if (snapshot.hasData) {
      var mydata = snapshot.data as List;
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          // we will display the data returned from our future here
          title: Text((snapshot.data[index] as Suggestion).description),
          onTap: () {
            close(
                context,
                snapshot.data == null
                    ? Suggestion('null', 'null')
                    : mydata[index]);
          },
        ),
        itemCount: mydata.length,
      );
    } else {
      return const Text('Loading...');
    }
  }
}
