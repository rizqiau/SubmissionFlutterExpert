import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

import '../../dummy_data/dummy_objects.dart'; // sesuaikan path

class MockSearchMoviesBloc extends Mock implements SearchMoviesBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMoviesEvent {}

class FakeSearchMoviesState extends Fake implements SearchMoviesState {}

Widget makeTestableWidget(Widget body, SearchMoviesBloc bloc) {
  return MaterialApp(
    home: BlocProvider<SearchMoviesBloc>.value(
      value: bloc,
      child: body,
    ),
  );
}

void main() {
  late MockSearchMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockBloc = MockSearchMoviesBloc();
    // Penting: stub getter .stream agar tidak null
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream<SearchMoviesState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const SearchMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(const SearchPage(), mockBloc));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan hasil pencarian saat loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const SearchPage(), mockBloc));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget); // dari testMovie
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal mencari film';
    when(() => mockBloc.state)
        .thenReturn(const SearchMoviesError(errorMessage));

    await tester.pumpWidget(makeTestableWidget(const SearchPage(), mockBloc));

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Menampilkan pesan initial saat belum ada pencarian',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const SearchMoviesInitial());

    await tester.pumpWidget(makeTestableWidget(const SearchPage(), mockBloc));

    expect(find.text('Start searching for movies!'), findsOneWidget);
  });

  testWidgets('Mengirim event OnQueryChanged saat mengetik di TextField',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const SearchMoviesInitial());

    await tester.pumpWidget(makeTestableWidget(const SearchPage(), mockBloc));

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'spider');
    await tester.pump();

    verify(() => mockBloc.add(const OnQueryChanged('spider'))).called(1);
  });
}
