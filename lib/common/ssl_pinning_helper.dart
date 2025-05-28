// ditonton/lib/common/ssl_pinning_helper.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart'; // Import ini untuk kDebugMode

class SslPinningHelper {
  static Future<IOClient> get _sslClient async {
    ByteData sslCertBytes;
    try {
      sslCertBytes =
          await rootBundle.load('assets/certificates/certificates.crt');
      if (sslCertBytes.lengthInBytes == 0) {
        // Ini adalah skenario yang sudah kamu uji dan menghasilkan TlsException, yang bagus.
        if (kDebugMode) {
          print(
              'SSL Pinning: certificates.crt is empty. Expecting TlsException.');
        }
        throw Exception('SSL Pinning: certificates.crt is empty or invalid.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SSL Pinning: Error loading certificate from assets: $e');
      }
      rethrow; // Biarkan error ini muncul jika sertifikat tidak bisa dimuat
    }

    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext
        .setTrustedCertificatesBytes(sslCertBytes.buffer.asUint8List());

    HttpClient client = HttpClient(context: securityContext);

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (kDebugMode) {
        print('SSL Pinning: --- badCertificateCallback invoked ---');
        print('SSL Pinning: Host trying to connect: $host');
        print('SSL Pinning: Certificate Subject: ${cert.subject}');
        print('SSL Pinning: Certificate Issuer: ${cert.issuer}');
        print('SSL Pinning: Certificate Start Date: ${cert.startValidity}');
        print('SSL Pinning: Certificate End Date: ${cert.endValidity}');
        // Print beberapa karakter pertama dari PEM untuk identifikasi
        print(
            'SSL Pinning: Certificate PEM (first 100 chars): ${cert.pem.substring(0, cert.pem.length < 100 ? cert.pem.length : 100)}...');
        print('SSL Pinning: --- End badCertificateCallback ---');
      }

      // Jika callback ini dipanggil, itu berarti sertifikat dari server TIDAK dipercaya oleh securityContext.
      // Dengan mengembalikan 'false', kita secara eksplisit MENOLAK koneksi.
      // Ini adalah inti dari SSL pinning.
      return false; // TOLAK koneksi jika sertifikat TIDAK dipercaya.
    };
    return IOClient(client);
  }

  static Future<IOClient> get client => _sslClient;
}
