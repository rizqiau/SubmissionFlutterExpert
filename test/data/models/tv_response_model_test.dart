import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    adult: false,
    backdropPath: "/qFfWFwfaEHzDLWLuttWiYq7Poy2.jpg",
    genreIds: [10767],
    id: 2261,
    originalName: "The Tonight Show Starring Johnny Carson",
    overview:
        "The Tonight Show Starring Johnny Carson is a talk show hosted by Johnny Carson under The Tonight Show franchise from 1962 to 1992. It originally aired during late-night. For its first ten years, Carson's Tonight Show was based in New York City with occasional trips to Burbank, California; in May 1972, the show moved permanently to Burbank, California. In 2002, The Tonight Show Starring Johnny Carson was ranked #12 on TV Guide's 50 Greatest TV Shows of All Time.",
    popularity: 689.8695,
    posterPath: "/uSvET5YUvHNDIeoCpErrbSmasFb.jpg",
    firstAirDate: "1962-10-01",
    voteAverage: 7.463,
    voteCount: 81,
  );
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_popular.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/qFfWFwfaEHzDLWLuttWiYq7Poy2.jpg",
            "genre_ids": [10767],
            "id": 2261,
            "original_name": "The Tonight Show Starring Johnny Carson",
            "overview":
                "The Tonight Show Starring Johnny Carson is a talk show hosted by Johnny Carson under The Tonight Show franchise from 1962 to 1992. It originally aired during late-night. For its first ten years, Carson's Tonight Show was based in New York City with occasional trips to Burbank, California; in May 1972, the show moved permanently to Burbank, California. In 2002, The Tonight Show Starring Johnny Carson was ranked #12 on TV Guide's 50 Greatest TV Shows of All Time.",
            "popularity": 689.8695,
            "poster_path": "/uSvET5YUvHNDIeoCpErrbSmasFb.jpg",
            "first_air_date": "1962-10-01",
            "vote_average": 7.463,
            "vote_count": 81
          }
        ],
      };
      // act
      final result = tTvResponseModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
