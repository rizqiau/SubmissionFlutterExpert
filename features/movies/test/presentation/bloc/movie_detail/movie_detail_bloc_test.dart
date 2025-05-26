import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart';
import 'package:movies/movies.dart';

import '../../../dummy_data/dummy_objects.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  const tId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(movieDetailBloc.state, const MovieDetailInitial());
  });

  // Test case: Get Movie Detail and Recommendations - Success
  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, MovieDetailHasData] when data is fetched successfully',
    build: () {
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(testMovieList));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
    expect: () => <MovieDetailState>[
      const MovieDetailLoading(),
      MovieDetailHasData(
        testMovieDetail,
        testMovieList,
      ), // Menggunakan state baru
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  // Test case: Get Movie Detail - Error, Recommendations - irrelevant (since detail failed)
  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when fetching movie detail fails',
    build: () {
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // Recommendations won't be called if detail fetching fails,
      // but if it were, we'd still expect an error for the main detail
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
        (_) async => Right(testMovieList),
      ); // This mock is less important here
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
    expect: () => <MovieDetailState>[
      const MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verifyNoMoreInteractions(
        mockGetMovieRecommendations,
      ); // Recommendations should not be called
    },
  );

  // Test case: Get Movie Detail - Success, Recommendations - Error
  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, MovieDetailHasData (with empty recommendations)] when fetching recommendations fails',
    build: () {
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Rekomendasi gagal
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
    expect: () => <MovieDetailState>[
      const MovieDetailLoading(),
      MovieDetailHasData(
        testMovieDetail,
        [],
      ), // Rekomendasi kosong jika gagal
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );
}
