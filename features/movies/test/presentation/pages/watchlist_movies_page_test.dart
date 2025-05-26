import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';

// Mock Bloc
class MockWatchlistMoviesBloc extends Mock implements WatchlistMoviesBloc {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMoviesEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMoviesState {}

Widget makeTestableWidget(Widget body, WatchlistMoviesBloc bloc) {
  return MaterialApp(
    home: BlocProvider<WatchlistMoviesBloc>.value(
      value: bloc,
      child: body,
    ),
  );
}

void main() {
  late MockWatchlistMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  setUp(() {
    mockBloc = MockWatchlistMoviesBloc();
    // Penting: stub getter .stream agar tidak null
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream<WatchlistMoviesState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistMoviesLoading());

    await tester
        .pumpWidget(makeTestableWidget(const WatchlistMoviesPage(), mockBloc));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistMoviesLoaded(testMovieList));

    await tester
        .pumpWidget(makeTestableWidget(const WatchlistMoviesPage(), mockBloc));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget); // Nama dari testMovie
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state)
        .thenReturn(const WatchlistMoviesError(errorMessage));

    await tester
        .pumpWidget(makeTestableWidget(const WatchlistMoviesPage(), mockBloc));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Menampilkan pesan kosong saat initial state', (tester) async {
    when(() => mockBloc.state).thenReturn(const WatchlistMoviesInitial());

    await tester
        .pumpWidget(makeTestableWidget(const WatchlistMoviesPage(), mockBloc));

    expect(find.text('Watchlist is empty or failed to load.'), findsOneWidget);
  });
}
