import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvNotifier notifier;
  late MockGetPopularTv mockGetPopularTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvNotifier(mockGetPopularTv)..addListener(() {
      listenerCallCount++;
    });
  });

  final tTv = testTv; // Menggunakan dummy data dari dummy_objects.dart
  final tTvList = <Tv>[tTv];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetPopularTv.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
