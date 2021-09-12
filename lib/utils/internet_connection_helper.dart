import 'dart:io';

class InternetConnectionHelper {
  Future<List<InternetAddress>> tryInternetConnection() async {
    try {
      final List<InternetAddress> response =
          await InternetAddress.lookup('www.google.com');
      return response;
    } catch (e) {
      if (e is SocketException) {
        return <InternetAddress>[];
      } else {
        throw Exception('$e');
      }
    }
  }
}
