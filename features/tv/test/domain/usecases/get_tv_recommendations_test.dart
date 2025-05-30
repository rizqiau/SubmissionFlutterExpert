import 'package:dartz/dartz.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  final tId = 1;
  final tTv = <Tv>[];

  test(
    'should get list of tv series recommendations from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.getTvRecommendations(tId),
      ).thenAnswer((_) async => Right(tTv));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTv));
    },
  );
}
