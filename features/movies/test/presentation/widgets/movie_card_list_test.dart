import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:movies/movies.dart'; // sesuaikan path
import '../../dummy_data/dummy_objects.dart';
import '../pages/search_page_test.dart'; // sesuaikan path

// Mock NavigatorObserver untuk cek navigasi
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

Widget makeTestableWidget(Widget body, {NavigatorObserver? observer}) {
  return MaterialApp(
    home: Scaffold(body: body),
    navigatorObservers: observer != null ? [observer] : [],
    routes: {
      MovieDetailPage.ROUTE_NAME: (context) => const Scaffold(
            body: Text('MovieDetailPage'),
          ),
    },
  );
}

void main() {
  late MockNavigatorObserver mockObserver;

  setUpAll(() {
    registerFallbackValue(FakeRoute()); // <-- Tambahkan ini
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets('Menampilkan judul, overview, dan poster', (tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.textContaining('After being bitten'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('Navigasi ke MovieDetailPage saat di-tap', (tester) async {
    await tester.pumpWidget(
        makeTestableWidget(MovieCard(testMovie), observer: mockObserver));

    final card = find.byType(InkWell);
    await tester.tap(card);
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    expect(find.text('MovieDetailPage'), findsOneWidget);
  });

  testWidgets('Menampilkan icon error jika poster gagal dimuat',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

    final image = find.byType(CachedNetworkImage);
    expect(image, findsOneWidget);

    // Simulasi errorWidget
    final widget = tester.widget<CachedNetworkImage>(image);
    final errorWidget =
        widget.errorWidget!(tester.element(image), '', Exception());
    expect(errorWidget is Icon, true);
  });
}
