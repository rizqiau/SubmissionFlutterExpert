import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SslPinningHelper {
  static Future<IOClient> get _sslClient async {
    final sslCert =
        await rootBundle.load('assets/certificates/certificates.crt');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }

  static Future<IOClient> get client => _sslClient;
}
