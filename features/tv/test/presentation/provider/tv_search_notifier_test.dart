import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tTv = testTv; // Menggunakan dummy data dari dummy_objects.dart
  final tTvList = <Tv>[tTv];
  final tQuery = 'Game of Thrones';

  group('search tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchTv.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvList));
        // act
        await provider.fetchTvSearch(tQuery);
        // assert
        expect(provider.state, RequestState.Loaded);
        expect(provider.searchResult, tTvList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
