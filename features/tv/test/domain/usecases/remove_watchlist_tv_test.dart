import 'package:dartz/dartz.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(
      mockTvRepository.removeWatchlistTv(testTvDetail),
    ).thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.removeWatchlistTv(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
