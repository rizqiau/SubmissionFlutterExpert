import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';

// Mock Bloc
class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}

class MockWatchlistMoviesBloc extends Mock implements WatchlistMoviesBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeWatchlistMoviesEvent extends Fake implements WatchlistMoviesEvent {}

class FakeWatchlistMoviesState extends Fake implements WatchlistMoviesState {}

Widget makeTestableWidget(Widget body, MovieDetailBloc movieDetailBloc,
    WatchlistMoviesBloc watchlistBloc) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: movieDetailBloc),
        BlocProvider<WatchlistMoviesBloc>.value(value: watchlistBloc),
      ],
      child: body,
    ),
  );
}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeWatchlistMoviesEvent());
    registerFallbackValue(FakeWatchlistMoviesState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();

    // Penting: Stub getter .stream agar tidak null
    when(() => mockMovieDetailBloc.stream)
        .thenAnswer((_) => Stream<MovieDetailState>.empty());
    when(() => mockWatchlistMoviesBloc.stream)
        .thenAnswer((_) => Stream<WatchlistMoviesState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading',
      (tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoading());
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(const WatchlistMoviesInitial());

    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        mockMovieDetailBloc,
        mockWatchlistMoviesBloc,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan detail movie dan rekomendasi saat data loaded',
      (tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailHasData(testMovieDetail, testMovieList),
    );
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(const WatchlistStatusLoaded(false));

    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        mockMovieDetailBloc,
        mockWatchlistMoviesBloc,
      ),
    );

    expect(find.text('title'), findsOneWidget); // Dari testMovieDetail.title
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(CachedNetworkImage),
        findsWidgets); // Poster dan rekomendasi
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat detail';
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailError(errorMessage));
    when(() => mockWatchlistMoviesBloc.state)
        .thenReturn(const WatchlistMoviesInitial());

    await tester.pumpWidget(
      makeTestableWidget(
        MovieDetailPage(id: 1),
        mockMovieDetailBloc,
        mockWatchlistMoviesBloc,
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);
  });
}
