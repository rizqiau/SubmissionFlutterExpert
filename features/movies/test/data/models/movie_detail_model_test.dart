import 'dart:convert';

import 'package:core/core.dart';
import 'package:movies/movies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test/dummy_data/dummy_objects.dart';
import '../../../test/json_reader.dart';

void main() {
  // Gunakan nilai dari testMovieDetail agar konsisten
  final tMovieDetailResponse = MovieDetailResponse(
    adult: testMovieDetail.adult,
    backdropPath: testMovieDetail.backdropPath,
    // budget, homepage, imdbId, originalLanguage, popularity, revenue, status, tagline, video
    // Tidak ada di MovieDetail entity, jadi kita bisa menggunakan nilai dari JSON dummy atau default
    budget: 100, // Nilai dummy dari movie_detail.json
    genres:
        testMovieDetail.genres
            .map((e) => GenreModel(id: e.id, name: e.name))
            .toList(),
    homepage: "https://google.com", // Nilai dummy dari movie_detail.json
    id: testMovieDetail.id,
    imdbId: 'imdb1', // Nilai dummy dari movie_detail.json
    originalLanguage: 'en', // Nilai dummy dari movie_detail.json
    originalTitle: testMovieDetail.originalTitle,
    overview: testMovieDetail.overview,
    popularity: 1.0, // Nilai dummy dari movie_detail.json
    posterPath: testMovieDetail.posterPath!,
    releaseDate: testMovieDetail.releaseDate,
    revenue: 12000, // Nilai dummy dari movie_detail.json
    runtime: testMovieDetail.runtime,
    status: 'Status', // Nilai dummy dari movie_detail.json
    tagline: 'Tagline', // Nilai dummy dari movie_detail.json
    title: testMovieDetail.title,
    video: false, // Nilai dummy dari movie_detail.json
    voteAverage: testMovieDetail.voteAverage,
    voteCount: testMovieDetail.voteCount,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      // act
      final result = MovieDetailResponse.fromJson(jsonMap);
      // assert
      // kita perlu membuat instance MovieDetailResponse yang sesuai dengan dummy_data/movie_detail.json
      // karena tMovieDetailResponse yang di atas dibuat berdasarkan testMovieDetail.
      final expectedMovieDetailResponseFromJson = MovieDetailResponse(
        adult: false,
        backdropPath: "/path.jpg",
        budget: 100,
        genres: [GenreModel(id: 1, name: "Action")],
        homepage: "https://google.com",
        id: 1,
        imdbId: "imdb1",
        originalLanguage: "en",
        originalTitle: "Original Title",
        overview: "Overview",
        popularity: 1.0,
        posterPath: "/path.jpg",
        releaseDate: "2020-05-05",
        revenue: 12000,
        runtime: 120,
        status: "Status",
        tagline: "Tagline",
        title: "Title",
        video: false,
        voteAverage: 1.0,
        voteCount: 1,
      );
      expect(result, expectedMovieDetailResponseFromJson);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "budget": 100,
        "genres": [
          {"id": 1, "name": "Action"},
        ],
        "homepage": "https://google.com",
        "id": 1,
        "imdb_id": "imdb1",
        "original_language": "en",
        "original_title": "Original Title",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "release_date": "2020-05-05",
        "revenue": 12000,
        "runtime": 120,
        "status": "Status",
        "tagline": "Tagline",
        "title": "Title",
        "video": false,
        "vote_average": 1.0,
        "vote_count": 1,
      };
      // act
      // Menggunakan tMovieDetailResponse yang sudah disesuaikan dengan nilai dari JSON dummy
      final result =
          MovieDetailResponse(
            adult: false,
            backdropPath: "/path.jpg",
            budget: 100,
            genres: [GenreModel(id: 1, name: 'Action')],
            homepage: "https://google.com",
            id: 1,
            imdbId: 'imdb1',
            originalLanguage: 'en',
            originalTitle: 'Original Title',
            overview: 'Overview',
            popularity: 1.0,
            posterPath: "/path.jpg",
            releaseDate: "2020-05-05",
            revenue: 12000,
            runtime: 120,
            status: 'Status',
            tagline: 'Tagline',
            title: 'Title',
            video: false,
            voteAverage: 1.0,
            voteCount: 1,
          ).toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should return a valid MovieDetail entity', () async {
      // act
      // tMovieDetailResponse di toEntity harus merepresentasikan data
      // dari dummy_objects.dart agar match dengan testMovieDetail
      final result =
          MovieDetailResponse(
            adult: testMovieDetail.adult,
            backdropPath: testMovieDetail.backdropPath,
            // Ini adalah field yang ada di model response tapi tidak ada di entity
            budget: 100,
            genres:
                testMovieDetail.genres
                    .map((e) => GenreModel(id: e.id, name: e.name))
                    .toList(),
            homepage: "https://google.com",
            id: testMovieDetail.id,
            imdbId: 'imdb1',
            originalLanguage: 'en',
            originalTitle: testMovieDetail.originalTitle,
            overview: testMovieDetail.overview,
            popularity: 1.0,
            posterPath: testMovieDetail.posterPath,
            releaseDate: testMovieDetail.releaseDate,
            revenue: 12000,
            runtime: testMovieDetail.runtime,
            status: 'Status',
            tagline: 'Tagline',
            title: testMovieDetail.title,
            video: false,
            voteAverage: testMovieDetail.voteAverage,
            voteCount: testMovieDetail.voteCount,
          ).toEntity();
      // assert
      expect(result, testMovieDetail);
    });
  });
}
