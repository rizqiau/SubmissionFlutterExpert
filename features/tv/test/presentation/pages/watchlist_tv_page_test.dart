import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

// Mock Bloc
class MockWatchlistTvBloc extends Mock implements WatchlistTvBloc {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

Widget makeTestableWidget(Widget body, WatchlistTvBloc bloc) {
  return MaterialApp(
    home: BlocProvider<WatchlistTvBloc>.value(value: bloc, child: body),
  );
}

void main() {
  late MockWatchlistTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockBloc = MockWatchlistTvBloc();
    // Penting: stub getter .stream agar tidak null
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream<WatchlistTvState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTvLoading());

    await tester.pumpWidget(
      makeTestableWidget(const WatchlistTvPage(), mockBloc),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTvLoaded(testTvList));

    await tester.pumpWidget(
      makeTestableWidget(const WatchlistTvPage(), mockBloc),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
    expect(find.text('The Last of Us'), findsOneWidget);
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state).thenReturn(const WatchlistTvError(errorMessage));

    await tester.pumpWidget(
      makeTestableWidget(const WatchlistTvPage(), mockBloc),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Menampilkan pesan kosong saat initial state', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistTvInitial());

    await tester.pumpWidget(
      makeTestableWidget(const WatchlistTvPage(), mockBloc),
    );

    expect(find.text('Watchlist is empty or failed to load.'), findsOneWidget);
  });
}
