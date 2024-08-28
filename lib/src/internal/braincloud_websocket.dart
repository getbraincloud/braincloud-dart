import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';

class BrainCloudWebSocket {
  late final WebSocketChannel _clientWebSocket;

  BrainCloudWebSocket(String url,
      {this.onOpen, this.onMessage, this.onError, this.onClose}) {
    _clientWebSocket = WebSocketChannel.connect(Uri.parse(url));
    if (onOpen != null) {
      onOpen!();
    }

    _clientWebSocket.stream.listen((data) {
      if (onMessage != null) {
        onMessage!(data: data);
      }
    }, onError: (error) {
      if (onError != null) {
        onError!(message: error.toString());
      }
    });
  }

  //  void StartReceivingClientWebSocketAsync() async
  // {
  //     await Task.Run(async () =>
  //     {
  //         try
  //         {
  //             ArraySegment<Byte> buffer = new ArraySegment<byte>(new Byte[8192]);
  //             WebSocketReceiveResult result = null;
  //             MemoryStream ms = new MemoryStream();
  //             while (ClientWebSocket != null)
  //             {
  //                 do
  //                 {
  //                     result = await ClientWebSocket.ReceiveAsync(buffer, CancellationToken.None);
  //                     ms.Write(buffer.Array, buffer.Offset, result.Count);
  //                 }
  //                 while (!result.EndOfMessage && ClientWebSocket != null);
  //                 ms.Seek(0, SeekOrigin.Begin);

  //                 if (!result.EndOfMessage)
  //                 {
  //                     // We probably closed the socket
  //                     break;
  //                 }

  //                 ClientWebSocket_OnMessage(ms.ToArray());
  //                 ms.SetLength(0);
  //             }
  //         }
  //         catch (ObjectDisposedException e)
  //         {
  //             ClientWebSocket_OnClose(e.Message);
  //         }
  //         catch (Exception e)
  //         {
  //             ClientWebSocket_OnError(e.Message);
  //         }
  //     });

  // }

  void close() {
    _clientWebSocket.sink.close();
  }

  void sendAsync(Uint8List packet) {
    _clientWebSocket.sink.add(packet);
  }

  void send(Uint8List packet) {
    sendAsync(packet);
  }

  OnOpenHandler? onOpen;
  OnMessageHandler? onMessage;
  OnErrorHandler? onError;
  OnCloseHandler? onClose;
}

typedef OnOpenHandler = void Function();

typedef OnMessageHandler = void Function({required Uint8List data});

typedef OnErrorHandler = void Function({required String message});

typedef OnCloseHandler = void Function(
    {required int code, required String reason});
