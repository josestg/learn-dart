import 'dart:core';
import 'dart:io';

typedef Handler = void Function(HttpRequest);

abstract class HttpHandler {
  void serveHTTP(HttpRequest request);
}


class Server {
  late Map<String, HttpHandler> _routes;
  Server() {
    _routes = {};
  }


  void handle(String path, HttpHandler h) {
    _routes[path] = h;
  }

  void listen(int port) {
    HttpServer.
    bind(InternetAddress.anyIPv6, port).
    then((server) {
      print('server is listening on localhost:$port');
      server.listen((HttpRequest request){
        print('got path: ${request.uri.path}');
        var h = _routes[request.uri.path];
        if (h != null) {
          h.serveHTTP(request);
        }
      });
    });
  }
}