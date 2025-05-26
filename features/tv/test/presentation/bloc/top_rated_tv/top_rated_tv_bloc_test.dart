// features/tv/test/presentation/bloc/top_rated_tv/top_rated_tv_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:tv/tv.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart';

import 'top_rated_tv_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetTopRatedTv])
void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(topRatedTvBloc.state, const TopRatedTvInitial());
  });

  // Test case: Get Top Rated Tv - Success
  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedTv()),
    expect:
        () => <TopRatedTvState>[
          const TopRatedTvLoading(),
          TopRatedTvLoaded(testTvList),
        ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );

  // Test case: Get Top Rated Tv - Error
  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedTv()),
    expect:
        () => <TopRatedTvState>[
          const TopRatedTvLoading(),
          const TopRatedTvError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );
}
