import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart'; // sesuaikan path

class MockSearchTvBloc extends Mock implements SearchTvBloc {}

class FakeSearchTvEvent extends Fake implements SearchTvEvent {}

class FakeSearchTvState extends Fake implements SearchTvState {}

Widget makeTestableWidget(Widget body, SearchTvBloc bloc) {
  return MaterialApp(
    home: BlocProvider<SearchTvBloc>.value(value: bloc, child: body),
  );
}

void main() {
  late MockSearchTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchTvEvent());
    registerFallbackValue(FakeSearchTvState());
  });

  setUp(() {
    mockBloc = MockSearchTvBloc();
    // Penting: stub getter .stream agar tidak null
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream<SearchTvState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const SearchTvLoading());

    await tester.pumpWidget(makeTestableWidget(const TvSearchPage(), mockBloc));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan hasil pencarian saat loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvLoaded(testTvList));

    await tester.pumpWidget(makeTestableWidget(const TvSearchPage(), mockBloc));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
    expect(find.text('The Last of Us'), findsOneWidget); // dari testMovie
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal mencari film';
    when(() => mockBloc.state).thenReturn(const SearchTvError(errorMessage));

    await tester.pumpWidget(makeTestableWidget(const TvSearchPage(), mockBloc));

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Menampilkan pesan initial saat belum ada pencarian', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const SearchTvInitial());

    await tester.pumpWidget(makeTestableWidget(const TvSearchPage(), mockBloc));

    expect(find.text('Start searching for tv series!'), findsOneWidget);
  });

  testWidgets('Mengirim event OnQueryChanged saat mengetik di TextField', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const SearchTvInitial());

    await tester.pumpWidget(makeTestableWidget(const TvSearchPage(), mockBloc));

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'the last of us');
    await tester.pump();

    verify(
      () => mockBloc.add(const OnQueryChanged('the last of us')),
    ).called(1);
  });
}
