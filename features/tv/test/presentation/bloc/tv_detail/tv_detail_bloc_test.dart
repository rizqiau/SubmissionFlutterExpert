import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';

import '../../../dummy_data/dummy_objects.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail, GetTvRecommendations])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;

  const tId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(tvDetailBloc.state, const TvDetailInitial());
  });

  // Test case: Get Tv Detail and Recommendations - Success
  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, TvDetailHasData] when data is fetched successfully',
    build: () {
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => Right(testTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(testTvList));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(tId)),
    expect:
        () => <TvDetailState>[
          const TvDetailLoading(),
          TvDetailHasData(testTvDetail, testTvList), // Menggunakan state baru
        ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  // Test case: Get Tv Detail - Error, Recommendations - irrelevant (since detail failed)
  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when fetching tv detail fails',
    build: () {
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // Recommendations won't be called if detail fetching fails,
      // but if it were, we'd still expect an error for the main detail
      when(mockGetTvRecommendations.execute(tId)).thenAnswer(
        (_) async => Right(testTvList),
      ); // This mock is less important here
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(tId)),
    expect:
        () => <TvDetailState>[
          const TvDetailLoading(),
          const TvDetailError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verifyNoMoreInteractions(
        mockGetTvRecommendations,
      ); // Recommendations should not be called
    },
  );

  // Test case: Get Tv Detail - Success, Recommendations - Error
  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, TvDetailHasData (with empty recommendations)] when fetching recommendations fails',
    build: () {
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId)).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Rekomendasi gagal
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(tId)),
    expect:
        () => <TvDetailState>[
          const TvDetailLoading(),
          TvDetailHasData(testTvDetail, []), // Rekomendasi kosong jika gagal
        ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );
}
