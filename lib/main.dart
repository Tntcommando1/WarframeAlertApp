import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

// RUN THE APP AND SET THE FEED TO WHATEVER THE FETCH FEED RETURNS (NEEDS MORE ERROR HANDLING)
void main() => runApp(MyApp(feed: fetchFeed()));

// URL OF THE RSS FEED
var url = 'http://content.warframe.com/dynamic/rss.php';

Future<RssFeed> fetchFeed() async {

  // DO AN HTTP REQUEST
  final response = await http.get(url);

  // PARSE THE HTTP REQUEST RESULT BODY INTO AN RSSFEED OBJECT
  return RssFeed.parse(response.body);
}

class MyApp extends StatelessWidget {
  final Future<RssFeed> feed;

  MyApp({Key key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // THE THEME IS A DARK THEME
      theme: ThemeData(
        brightness: Brightness.dark,
      ),

      home: Scaffold(
        // TOP MENU BAR
        appBar: AppBar(
          title: new Text("Warframe"),
          leading: Icon(Icons.menu),
          centerTitle: true,
        ),

        // BODY OF APP
        body: Center(
          child: Container(

            // CREATE PADDING AROUND THE FUTURE BUILDER
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: FutureBuilder<RssFeed>(future: feed, builder: (context, snapshot) {

              // IF THE FEED RETURNS DATA
              if(snapshot.hasData){

                // USE A LIST BUILDER
                return ListView.builder(

                  // THE NUMBER OF ITEMS MATCH THE NUMBER OF OBJECTS IN THE ITEMS LIST IN THE SNAPSHOT
                  itemCount: snapshot.data.items.length,

                  // BASICALLY A FOR LOOP BUT FOR THE LIST BUILDER INDEX IS LIKE THE VARIABLE
                  itemBuilder: (context, index) {

                    // RETURN A LIST TILE AT EACH POSITION WITH THE CORRESPONDING DATA
                    return new ListTile(
                      title: Text(snapshot.data.items[index].title),
                      subtitle: Text(snapshot.data.items[index].author),
                      leading: Icon(Icons.assignment),
                    );
                  },
                );
              }
              // IF THE FEED DOES NOT RETURN DATA... LOAD
              return CircularProgressIndicator();
            })
          )
        ) 
      )
    );
  }
}