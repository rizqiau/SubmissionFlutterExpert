import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart'; // Pastikan path ini sesuai dengan struktur project kamu

// Mock Bloc
class MockTopRatedTvBloc extends Mock implements TopRatedTvBloc {}

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

void main() {
  late MockTopRatedTvBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
  });

  setUp(() {
    mockBloc = MockTopRatedTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedTvBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TopRatedTvLoading());
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([const TopRatedTvLoading()]),
      initialState: const TopRatedTvLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan ListView saat data loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvLoaded(testTvList));
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([TopRatedTvLoaded(testTvList)]),
      initialState: TopRatedTvLoaded(testTvList),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
    expect(find.text('The Last of Us'), findsOneWidget);
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat data';
    when(() => mockBloc.state).thenReturn(const TopRatedTvError(errorMessage));
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([
        const TopRatedTvError(errorMessage),
      ]),
      initialState: const TopRatedTvError(errorMessage),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
