import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Menggunakan relative import agar aman dari error perbedaan nama package projek
import '../lib/main.dart'; 

void main() {
  // Pasang sistem bypass internet sebelum testing dimulai
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('Test Alur Navigasi Movie App Praktikum PAB', (WidgetTester tester) async {
    // 1. Jalankan/Pump widget utama MovieApp
    await tester.pumpWidget(const MovieApp());

    // 2. Verifikasi awal: Pastikan judul "PRAKTIKUM PAB" muncul di halaman utama (Home)
    expect(find.text('PRAKTIKUM PAB'), findsOneWidget);
    
    // Pastikan kita melihat item grid film (mencari teks "Movie Title 1")
    expect(find.text('Movie Title 1'), findsOneWidget);

    // 3. Simulasikan Navigasi: Klik pada poster film pertama untuk pindah ke halaman Detail
    await tester.tap(find.text('Movie Title 1'));
    await tester.pumpAndSettle(); // Tunggu sampai transisi halaman selesai

    // 4. Verifikasi Halaman Detail: Pastikan tombol "Play" sekarang sudah muncul di layar
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Interstellar: Redux'), findsOneWidget);

    // 5. Simulasikan klik tombol Play
    await tester.tap(find.text('Play'));
    await tester.pump(); // Pump untuk memunculkan SnackBar

    // Verifikasi apakah SnackBar pesan memutar film berhasil muncul
    expect(find.text('Memutar Film: Interstellar...'), findsOneWidget);
  });
}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => MockHttpClient();
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => MockHttpClientRequest();
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null; // Otomatis handle method bawaan lain
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse();
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200; // Berpura-pura internet sukses (OK)
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// Data biner untuk gambar 1x1 piksel transparan format PNG
final List<int> _transparentImage = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82
];