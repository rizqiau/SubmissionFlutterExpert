import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularTvBloc extends Mock implements PopularTvBloc {}

class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

void main() {
  late MockPopularTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());
  });

  setUp(() {
    mockBloc = MockPopularTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularTvBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const PopularTvLoading());
    whenListen(
      mockBloc,
      Stream<PopularTvState>.fromIterable([const PopularTvLoading()]),
      initialState: const PopularTvLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvLoaded(testTvList));
    whenListen(
      mockBloc,
      Stream<PopularTvState>.fromIterable([PopularTvLoaded(testTvList)]),
      initialState: PopularTvLoaded(testTvList),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
    expect(find.text('The Last of Us'), findsOneWidget);
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state).thenReturn(const PopularTvError(errorMessage));
    whenListen(
      mockBloc,
      Stream<PopularTvState>.fromIterable([const PopularTvError(errorMessage)]),
      initialState: const PopularTvError(errorMessage),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
