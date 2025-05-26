// features/movies/test/presentation/bloc/now_playing_movies/now_playing_movies_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:movies/movies.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk dummymovieList

import 'now_playing_movies_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(nowPlayingMoviesBloc.state, const NowPlayingMoviesInitial());
  });

  // Test case: Get Now Playing Movies - Success
  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
    expect:
        () => <NowPlayingMoviesState>[
          const NowPlayingMoviesLoading(),
          NowPlayingMoviesLoaded(testMovieList),
        ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  // Test case: Get Now Playing Movies - Error
  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
    expect:
        () => <NowPlayingMoviesState>[
          const NowPlayingMoviesLoading(),
          const NowPlayingMoviesError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );
}
