import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:tv/tv.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart';

import 'on_the_air_tv_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([GetOnTheAirTv])
void main() {
  late OnTheAirTvBloc onTheAirTvBloc;
  late MockGetOnTheAirTv mockGetOnTheAirTv;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    onTheAirTvBloc = OnTheAirTvBloc(mockGetOnTheAirTv);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(onTheAirTvBloc.state, const OnTheAirTvInitial());
  });

  // Test case: Get Now Playing Tv - Success
  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return onTheAirTvBloc;
    },
    act: (bloc) => bloc.add(const FetchOnTheAirTv()),
    expect:
        () => <OnTheAirTvState>[
          const OnTheAirTvLoading(),
          OnTheAirTvLoaded(testTvList),
        ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );

  // Test case: Get Now Playing Movies - Error
  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(
        mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirTvBloc;
    },
    act: (bloc) => bloc.add(const FetchOnTheAirTv()),
    expect:
        () => <OnTheAirTvState>[
          const OnTheAirTvLoading(),
          const OnTheAirTvError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );
}
