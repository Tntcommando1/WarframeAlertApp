import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'httpFeed.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'util/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  // FEED FOR THE LIST
  Future<RssFeed> feed = fetchFeed(urlPC);

  // CURRENT NAVIGATION INDEX
  int navIndex = 0;

  // TITLE OF THE APP BAR
  String title = "WARFRAME PC";

  // SET THE TAB INDEX AND SET THE FEED DATA WHILE RESETTING THE STATE
  void incrementTab(index) {
    setState(() {
      navIndex = index;
      setFeedData(index);
    });
  }

  Future<void> refreshFeed() async {
    setState(() {
      setFeedData(navIndex);
    });
  }

  // CHECK THE CURRENT INDEX AND CHANGE VALUES ACCORDINGLY
  void setFeedData(int index) {
    if(index == 0) {
      feed = fetchFeed(urlPC);
      title = "WARFRAME PC";
    }
    else if(index == 1){
      feed = fetchFeed(urlPS4);
      title = "WARFRAME PS4";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // THE THEME IS A DARK THEME
      theme: Constants.darkTheme,

      home: Scaffold(
        // TOP MENU BAR
        appBar: AppBar(
          title: new Text(title),
          centerTitle: true,

        ),

        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.computer, title: "PC"),
            TabData(iconData: Icons.gamepad, title: "PS4"),
          ],
          onTabChangedListener: (position) => incrementTab(position),
          barBackgroundColor: Constants.darkAccent,
          circleColor: Constants.darkBG,
          textColor: Constants.darkBG,
          activeIconColor: Constants.darkAccent,
          inactiveIconColor: Constants.darkBG,
        ),

        // BODY OF APP
        body: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: RefreshIndicator(
              child: FutureBuilder<RssFeed>(future: feed, builder: (context, snapshot) {
                // IF THE FEED RETURNS DATA
                if(snapshot.hasData){
                  return Column (
                    children: <Widget>[

                      // DIVIDING LINE FOR DETAIL
                      Divider(height: 10, color: Constants.darkAccent, indent: 20, endIndent: 20,),

                      // EXPAND OUT THE REST
                      Expanded(
                        child: 
                          // USE A LIST BUILDER
                          ListView.builder(
                          // THE NUMBER OF ITEMS MATCH THE NUMBER OF OBJECTS IN THE ITEMS LIST IN THE SNAPSHOT
                          itemCount: snapshot.data.items.length,

                          // BASICALLY A FOR LOOP BUT FOR THE LIST BUILDER INDEX IS LIKE THE VARIABLE
                          itemBuilder: (context, index) {

                            // RETURN A LIST TILE AT EACH POSITION WITH THE CORRESPONDING DATA
                            return new ListTile(
                              title: Text(snapshot.data.items[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Open Sans')),
                              subtitle: Text(snapshot.data.items[index].author, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, fontFamily: 'Open Sans')),
                              leading: Icon(Icons.assignment),
                            );
                          },
                        )
                      ),
                      
                    ],
                  );
                }

                if(snapshot.hasError) {
                  return Text(snapshot.error);
                }

                // IF THE FEED DOES NOT RETURN DATA... LOAD
                return CircularProgressIndicator();
              }),
              onRefresh: refreshFeed,
            ),
          )
        ) 
      )
    );
  }
}