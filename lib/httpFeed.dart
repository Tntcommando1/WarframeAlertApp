import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

// URL OF THE RSS FEED
var urlPC = 'http://content.warframe.com/dynamic/rss.php';
var urlPS4 = 'http://content.ps4.warframe.com/dynamic/rss.php';

Future<RssFeed> fetchFeed(var url) async {
  
  // DO AN HTTP REQUEST
  final response = await http.get(url);

  // PARSE THE HTTP REQUEST RESULT BODY INTO AN RSSFEED OBJECT
  return RssFeed.parse(response.body);
}