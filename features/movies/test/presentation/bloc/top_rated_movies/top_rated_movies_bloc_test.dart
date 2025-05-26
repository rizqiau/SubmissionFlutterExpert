// features/movies/test/presentation/bloc/top_rated_movies/top_rated_movies_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:movies/movies.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk testMovieList

import 'top_rated_movies_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(topRatedMoviesBloc.state, const TopRatedMoviesInitial());
  });

  // Test case: Get Top Rated Movies - Success
  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovies()),
    expect:
        () => <TopRatedMoviesState>[
          const TopRatedMoviesLoading(),
          TopRatedMoviesLoaded(testMovieList),
        ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  // Test case: Get Top Rated Movies - Error
  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovies()),
    expect:
        () => <TopRatedMoviesState>[
          const TopRatedMoviesLoading(),
          const TopRatedMoviesError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
