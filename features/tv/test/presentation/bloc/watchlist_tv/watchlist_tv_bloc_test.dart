// features/tv/test/presentation/bloc/watchlist_tv/watchlist_tv_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:tv/tv.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk dummy data

import 'watchlist_tv_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([
  GetWatchlistTv,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  const tId = 1;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();

    watchlistTvBloc = WatchlistTvBloc(
      getWatchlistTv: mockGetWatchlistTv,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(watchlistTvBloc.state, const WatchlistTvInitial());
  });

  // Test case: Fetch Watchlist Tv - Success
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Loaded] when fetching watchlist tv successfully',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTv()),
    expect:
        () => <WatchlistTvState>[
          const WatchlistTvLoading(),
          WatchlistTvLoaded(testTvList),
        ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  // Test case: Fetch Watchlist Tv - Error
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when fetching watchlist tv fails',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTv()),
    expect:
        () => <WatchlistTvState>[
          const WatchlistTvLoading(),
          const WatchlistTvError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  // Test case: Load Watchlist Status - Added to Watchlist
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [WatchlistStatusLoaded(true)] when tv series is added to watchlist',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
    expect: () => <WatchlistTvState>[const WatchlistStatusLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  // Test case: Load Watchlist Status - Not in Watchlist
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [WatchlistStatusLoaded(false)] when tv series is not in watchlist',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
    expect: () => <WatchlistTvState>[const WatchlistStatusLoaded(false)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  // Test case: Add Tv Series to Watchlist - Success
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [WatchlistMessage] when adding tv series to watchlist succeeds',
    build: () {
      when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer(
        (_) async => const Right(WatchlistTvBloc.watchlistAddSuccessMessage),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
    expect:
        () => <WatchlistTvState>[
          const WatchlistMessage(WatchlistTvBloc.watchlistAddSuccessMessage),
        ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testTvDetail));
    },
  );

  // Test case: Add Tv Series to Watchlist - Error
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Error] when adding tv series to watchlist fails',
    build: () {
      when(
        mockSaveWatchlist.execute(testTvDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
    expect:
        () => <WatchlistTvState>[const WatchlistTvError('Database Failure')],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testTvDetail));
    },
  );

  // Test case: Remove Tv Series from Watchlist - Success
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [WatchlistMessage] when removing tv series from watchlist succeeds',
    build: () {
      when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer(
        (_) async => const Right(WatchlistTvBloc.watchlistRemoveSuccessMessage),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTvs(testTvDetail)),
    expect:
        () => <WatchlistTvState>[
          const WatchlistMessage(WatchlistTvBloc.watchlistRemoveSuccessMessage),
        ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testTvDetail));
    },
  );

  // Test case: Remove Tv Series from Watchlist - Error
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Error] when removing tv series from watchlist fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(testTvDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTvs(testTvDetail)),
    expect:
        () => <WatchlistTvState>[const WatchlistTvError('Database Failure')],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testTvDetail));
    },
  );
}
