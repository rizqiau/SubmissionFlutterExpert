import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

class FakePopularMoviesEvent extends Fake implements PopularMoviesEvent {}

class FakePopularMoviesState extends Fake implements PopularMoviesState {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
  });

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularMoviesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('Menampilkan CircularProgressIndicator saat loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const PopularMoviesLoading());
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable([const PopularMoviesLoading()]),
      initialState: const PopularMoviesLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesLoaded(testMovieList));
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable(
          [PopularMoviesLoaded(testMovieList)]),
      initialState: PopularMoviesLoaded(testMovieList),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state)
        .thenReturn(const PopularMoviesError(errorMessage));
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable(
          [const PopularMoviesError(errorMessage)]),
      initialState: const PopularMoviesError(errorMessage),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
