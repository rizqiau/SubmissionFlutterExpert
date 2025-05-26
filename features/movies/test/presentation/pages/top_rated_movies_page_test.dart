import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart'; // Pastikan path ini sesuai dengan struktur project kamu

// Mock Bloc
class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedMoviesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('Menampilkan CircularProgressIndicator saat loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const TopRatedMoviesLoading());
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable([const TopRatedMoviesLoading()]),
      initialState: const TopRatedMoviesLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedMoviesLoaded(testMovieList));
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable(
          [TopRatedMoviesLoaded(testMovieList)]),
      initialState: TopRatedMoviesLoaded(testMovieList),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget); // Nama dari testMovie
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state)
        .thenReturn(const TopRatedMoviesError(errorMessage));
    whenListen(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable(
          [const TopRatedMoviesError(errorMessage)]),
      initialState: const TopRatedMoviesError(errorMessage),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
