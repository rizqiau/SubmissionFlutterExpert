import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:tv/tv.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart';

import 'popular_tv_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(popularTvBloc.state, const PopularTvInitial());
  });

  // Test case: Get Popular Tv - Success
  blocTest<PopularTvBloc, PopularTvState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTv()),
    expect:
        () => <PopularTvState>[
          const PopularTvLoading(),
          PopularTvLoaded(testTvList),
        ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );

  // Test case: Get Popular Tv - Error
  blocTest<PopularTvBloc, PopularTvState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTv()),
    expect:
        () => <PopularTvState>[
          const PopularTvLoading(),
          const PopularTvError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
    },
  );
}
