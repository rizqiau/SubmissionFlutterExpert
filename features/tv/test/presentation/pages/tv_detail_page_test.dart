import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

// Mock Bloc
class MockTvDetailBloc extends Mock implements TvDetailBloc {}

class MockWatchlistTvBloc extends Mock implements WatchlistTvBloc {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

Widget makeTestableWidget(
  Widget body,
  TvDetailBloc tvDetailBloc,
  WatchlistTvBloc watchlistBloc,
) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>.value(value: tvDetailBloc),
        BlocProvider<WatchlistTvBloc>.value(value: watchlistBloc),
      ],
      child: body,
    ),
  );
}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
    mockWatchlistTvBloc = MockWatchlistTvBloc();

    // Penting: Stub getter .stream agar tidak null
    when(
      () => mockTvDetailBloc.stream,
    ).thenAnswer((_) => Stream<TvDetailState>.empty());
    when(
      () => mockWatchlistTvBloc.stream,
    ).thenAnswer((_) => Stream<WatchlistTvState>.empty());
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading', (
    tester,
  ) async {
    when(() => mockTvDetailBloc.state).thenReturn(const TvDetailLoading());
    when(
      () => mockWatchlistTvBloc.state,
    ).thenReturn(const WatchlistTvInitial());

    await tester.pumpWidget(
      makeTestableWidget(
        TvDetailPage(id: 1),
        mockTvDetailBloc,
        mockWatchlistTvBloc,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Menampilkan detail tv series dan rekomendasi saat data loaded', (
    tester,
  ) async {
    when(
      () => mockTvDetailBloc.state,
    ).thenReturn(TvDetailHasData(testTvDetail, testTvList));
    when(
      () => mockWatchlistTvBloc.state,
    ).thenReturn(const WatchlistStatusLoaded(false));

    await tester.pumpWidget(
      makeTestableWidget(
        TvDetailPage(id: 1),
        mockTvDetailBloc,
        mockWatchlistTvBloc,
      ),
    );

    expect(find.text('name'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(
      find.byType(CachedNetworkImage),
      findsWidgets,
    ); // Poster dan rekomendasi
  });

  testWidgets('Menampilkan pesan error saat error', (tester) async {
    const errorMessage = 'Gagal memuat detail';
    when(
      () => mockTvDetailBloc.state,
    ).thenReturn(const TvDetailError(errorMessage));
    when(
      () => mockWatchlistTvBloc.state,
    ).thenReturn(const WatchlistTvInitial());

    await tester.pumpWidget(
      makeTestableWidget(
        TvDetailPage(id: 1),
        mockTvDetailBloc,
        mockWatchlistTvBloc,
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);
  });
}
