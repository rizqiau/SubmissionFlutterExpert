// features/movies/test/presentation/bloc/watchlist_movies/watchlist_movies_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:movies/movies.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk dummy data

import 'watchlist_movies_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const tId = 1;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    watchlistMoviesBloc = WatchlistMoviesBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(watchlistMoviesBloc.state, const WatchlistMoviesInitial());
  });

  // Test case: Fetch Watchlist Movies - Success
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Loaded] when fetching watchlist movies successfully',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovies()),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMoviesLoading(),
          WatchlistMoviesLoaded(testMovieList),
        ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  // Test case: Fetch Watchlist Movies - Error
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Loading, Error] when fetching watchlist movies fails',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovies()),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMoviesLoading(),
          const WatchlistMoviesError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  // Test case: Load Watchlist Status - Added to Watchlist
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [WatchlistStatusLoaded(true)] when movie is added to watchlist',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
    expect: () => <WatchlistMoviesState>[const WatchlistStatusLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  // Test case: Load Watchlist Status - Not in Watchlist
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [WatchlistStatusLoaded(false)] when movie is not in watchlist',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
    expect: () => <WatchlistMoviesState>[const WatchlistStatusLoaded(false)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  // Test case: Add Movie to Watchlist - Success
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [WatchlistMessage] when adding movie to watchlist succeeds',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async =>
            const Right(WatchlistMoviesBloc.watchlistAddSuccessMessage),
      );
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMessage(
            WatchlistMoviesBloc.watchlistAddSuccessMessage,
          ),
        ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  // Test case: Add Movie to Watchlist - Error
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Error] when adding movie to watchlist fails',
    build: () {
      when(
        mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMoviesError('Database Failure'),
        ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  // Test case: Remove Movie from Watchlist - Success
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [WatchlistMessage] when removing movie from watchlist succeeds',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async =>
            const Right(WatchlistMoviesBloc.watchlistRemoveSuccessMessage),
      );
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMessage(
            WatchlistMoviesBloc.watchlistRemoveSuccessMessage,
          ),
        ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  // Test case: Remove Movie from Watchlist - Error
  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Should emit [Error] when removing movie from watchlist fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovie(testMovieDetail)),
    expect:
        () => <WatchlistMoviesState>[
          const WatchlistMoviesError('Database Failure'),
        ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );
}
