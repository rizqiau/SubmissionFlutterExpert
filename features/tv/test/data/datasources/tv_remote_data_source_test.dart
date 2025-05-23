import 'dart:convert';

import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Series', () {
    final tTvList =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/tv_on_the_air.json')),
        ).tvList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200),
        );
        // act
        final result = await dataSource.getOnTheAirTv();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tTvList =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/tv_popular.json')),
        ).tvList;

    test(
      'should return list of TV Series when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200),
        );
        // act
        final result = await dataSource.getPopularTv();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tTvList =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/tv_top_rated.json')),
        ).tvList;

    test(
      'should return list of TV Series when response code is 200 ',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200),
        );
        // act
        final result = await dataSource.getTopRatedTv();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series detail', () {
    final tId = 1;
    final tTvList = TvDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test(
      'should return TV Series detail when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200),
        );
        // act
        final result = await dataSource.getTvDetail(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series recommendations', () {
    final tTvList =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/tv_recommendations.json')),
        ).tvList;
    final tId = 1;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search TV Series', () {
    final tSearchResult =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/search_the_last_of_us.json')),
        ).tvList;
    final tQuery = 'The Last of Us';

    test('should return list of TV Series when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_the_last_of_us.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchTv(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTv(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
