import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    adult: false,
    backdropPath: "/qFfWFwfaEHzDLWLuttWiYq7Poy2.jpg",
    episodeRunTime: [60],
    firstAirDate: "1962-10-01",
    genres: [GenreModel(id: 10767, name: "Talk")],
    id: 2261,
    languages: ["en"],
    lastAirDate: "1992-05-22",
    name: "The Tonight Show Starring Johnny Carson",
    numberOfEpisodes: 3638,
    numberOfSeasons: 31,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "The Tonight Show Starring Johnny Carson",
    overview:
        "The Tonight Show Starring Johnny Carson is a talk show hosted by Johnny Carson under The Tonight Show franchise from 1962 to 1992. It originally aired during late-night. For its first ten years, Carson's Tonight Show was based in New York City with occasional trips to Burbank, California; in May 1972, the show moved permanently to Burbank, California. In 2002, The Tonight Show Starring Johnny Carson was ranked #12 on TV Guide's 50 Greatest TV Shows of All Time.",
    popularity: 689.8695,
    posterPath: "/uSvET5YUvHNDIeoCpErrbSmasFb.jpg",
    status: "Ended",
    type: "Talk Show",
    voteAverage: 7.463,
    voteCount: 81,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));
      // act
      final result = TvDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/qFfWFwfaEHzDLWLuttWiYq7Poy2.jpg",
        "episode_run_time": [60],
        "first_air_date": "1962-10-01",
        "genres": [
          {"id": 10767, "name": "Talk"}
        ],
        "id": 2261,
        "languages": ["en"],
        "last_air_date": "1992-05-22",
        "name": "The Tonight Show Starring Johnny Carson",
        "number_of_episodes": 3638,
        "number_of_seasons": 31,
        "origin_country": ["US"],
        "original_language": "en",
        "original_name": "The Tonight Show Starring Johnny Carson",
        "overview":
            "The Tonight Show Starring Johnny Carson is a talk show hosted by Johnny Carson under The Tonight Show franchise from 1962 to 1992. It originally aired during late-night. For its first ten years, Carson's Tonight Show was based in New York City with occasional trips to Burbank, California; in May 1972, the show moved permanently to Burbank, California. In 2002, The Tonight Show Starring Johnny Carson was ranked #12 on TV Guide's 50 Greatest TV Shows of All Time.",
        "popularity": 689.8695,
        "poster_path": "/uSvET5YUvHNDIeoCpErrbSmasFb.jpg",
        "status": "Ended",
        "type": "Talk Show",
        "vote_average": 7.463,
        "vote_count": 81
      };
      // act
      final result = tTvDetailResponse.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should return a valid TvDetail entity', () async {
      // act
      final result = TvDetailResponse(
        adult: testTvDetail.adult!,
        backdropPath: testTvDetail.backdropPath,
        episodeRunTime: testTvDetail.episodeRunTime,
        firstAirDate: testTvDetail.firstAirDate,
        genres: testTvDetail.genres
            .map((e) => GenreModel(id: e.id, name: e.name))
            .toList(),
        id: testTvDetail.id,
        languages: testTvDetail.languages!,
        lastAirDate: testTvDetail.lastAirDate,
        name: testTvDetail.name,
        numberOfEpisodes: testTvDetail.numberOfEpisodes,
        numberOfSeasons: testTvDetail.numberOfSeasons,
        originCountry: testTvDetail.originCountry!,
        originalLanguage: testTvDetail.originalLanguage!,
        originalName: testTvDetail.originalName!,
        overview: testTvDetail.overview!,
        popularity: testTvDetail.popularity!,
        posterPath: testTvDetail.posterPath!,
        status: testTvDetail.status!,
        type: testTvDetail.type!,
        voteAverage: testTvDetail.voteAverage,
        voteCount: testTvDetail.voteCount,
      ).toEntity();
      // assert
      expect(result, testTvDetail);
    });
  });
}
