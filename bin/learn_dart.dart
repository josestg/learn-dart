import 'dart:io';
import 'package:learn_dart/server/server.dart';

class User {
  final String name;
  User(this.name);

  @override
  String toString() {
    return 'Name: $name';
  }
}

abstract class UserRepo {
  User findByID();
}

class UserStore implements UserRepo {
  @override
  User findByID() {
    return User('jose');
  }
}

class UserHandler implements HttpHandler {

  final UserRepo repo;

  UserHandler(this.repo);

  void _getAllUsers(HttpRequest request) {
    request.response.write(repo.findByID());
    request.response.close();
  }

  void _addNewUser(HttpRequest request) {
    request.response.write('add new user');
    request.response.close();
  }

  @override
  void serveHTTP(HttpRequest request) {
    var method = request.method;
    switch (method) {
      case 'GET':
        _getAllUsers(request);
        break;
      case 'POST':
        _addNewUser(request);
        break;
      default:
        request.response.statusCode = HttpStatus.methodNotAllowed;
        request.response.write('method not allowed');
        request.response.close();
    }
  }
}

class ProductHandler implements HttpHandler {
  void _getProducts(HttpRequest request) {
    request.response.write('show all products');
    request.response.close();
  }

  @override
  void serveHTTP(HttpRequest request) {
    var method = request.method;
    switch (method) {
      case 'GET':
        _getProducts(request);
        break;
      default:
        request.response.statusCode = HttpStatus.methodNotAllowed;
        request.response.write('method not allowed');
        request.response.close();
    }
  }
}

void main(List<String> arguments) {
  final s = Server();

  var userStore = UserStore();
  var userHandler = UserHandler(userStore);
  var productHandler = ProductHandler();

  s.handle('/users', userHandler);
  s.handle('/products', productHandler);

  s.listen(8080);
}
