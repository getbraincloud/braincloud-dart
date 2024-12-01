import 'dart:async';
import 'dart:io';


class WebSocketProxy {
  final String remoteServerUrl;
  late HttpServer _proxyServer;
  late WebSocket _clientSocket;

  WebSocketProxy(this.remoteServerUrl);

  /// Starts the proxy server on a specified port and returns the WebSocket
  /// connected to the local client.
  void startProxy({int port = 8080}) async {
    _proxyServer = await HttpServer.bind('localhost', port);
    print('Proxy server running on ws://localhost:$port');

    // Listen for incoming WebSocket connections from the client
    _proxyServer.transform(WebSocketTransformer()).listen((WebSocket clientSocket) async {
      print(' Client connected to proxy');
      _clientSocket = clientSocket;

      // Connect to the remote WebSocket server
      try {
        final actualServerSocket = await WebSocket.connect(remoteServerUrl);
        print('Proxy connected to actual WebSocket server');

        // Forward messages from client to actual server
        _clientSocket.listen(
          (message) {
            print('Message from client to actual server: $message');
            actualServerSocket.add(message);
          },
          onError: (error) {
            print('Error on client socket: $error');
            actualServerSocket.close();
          },
          onDone: () {
            print('Client socket closed');
            actualServerSocket.close();
          },
        );

        // Forward messages from actual server to client
        actualServerSocket.listen(
          (message) {
            print('Message from actual server to client: $message');
            _clientSocket.add(message);
          },
          onError: (error) {
            print('Error on actual server socket: $error');
            _clientSocket.close();
          },
          onDone: () {
            print('Actual server socket closed');
            _clientSocket.close();
          },
        );

        // Return the WebSocket connection with the client
        // return _clientSocket;
      } catch (error) {
        print('Failed to connect to actual WebSocket server: $error');
        _clientSocket.close();
      }
    });

  }

  /// Closes the proxy server and associated sockets
  Future<void> stopProxy() async {
    print('Stopping proxy server...');
    await _proxyServer.close();
    _clientSocket.close();
  }

  /// Simulates a connection drop by closing the client and server connections
  void simulateConnectionDrop() {
    print('Simulating connection drop');
    _clientSocket.close(); // Close the client connection
  }
}