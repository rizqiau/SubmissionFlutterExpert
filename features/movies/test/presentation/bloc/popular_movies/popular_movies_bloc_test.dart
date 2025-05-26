// features/movies/test/presentation/bloc/popular_movies/popular_movies_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:movies/movies.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk testMovieList

import 'popular_movies_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(popularMoviesBloc.state, const PopularMoviesInitial());
  });

  // Test case: Get Popular Movies - Success
  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularMovies()),
    expect:
        () => <PopularMoviesState>[
          const PopularMoviesLoading(),
          PopularMoviesLoaded(testMovieList),
        ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  // Test case: Get Popular Movies - Error
  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularMovies()),
    expect:
        () => <PopularMoviesState>[
          const PopularMoviesLoading(),
          const PopularMoviesError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
