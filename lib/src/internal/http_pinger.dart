import 'dart:async';

import 'package:http/http.dart' as http;

class HttpPigner {
  final Uri url;
  String error = "";
  bool isDone = false;

  HttpPigner(this.url);

  /// Sends a ping and measures the response time.
  /// Returns the response time in milliseconds or throws an error if it fails.
  Future<int> ping() async {
    Completer<int> completer = Completer();
    final stopwatch = Stopwatch()..start();
    try {
      // Sending a HEAD request to check if the server is responsive
      final request = http.Request('HEAD',url);
      request.headers['Cache-Control'] = 'no-cache';
      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 5));
      stopwatch.stop();
      isDone = true;
      // Ensure the response is valid
      if (response.statusCode >= 200 && response.statusCode < 500) {
        completer.complete(stopwatch.elapsedMilliseconds);
      } else {        
        error ='Failed to ping: HTTP status ${response.statusCode}';
        completer.complete(0);
      }
    } catch (e) {
      stopwatch.stop();
      error = e.toString();
      isDone = true;
      completer.complete(0);
    }
    return completer.future;
  }
}