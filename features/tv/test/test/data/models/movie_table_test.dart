import 'package:movies/movies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('fromEntity', () {
    test('should return a valid model from MovieDetail entity', () async {
      // act
      final result = MovieTable.fromEntity(testMovieDetail);
      // assert
      expect(result, tMovieTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        'id': 1,
        'title': 'title',
        'posterPath': 'posterPath',
        'overview': 'overview',
      };
      // act
      final result = tMovieTable.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should return a valid Movie entity', () async {
      // act
      final result = tMovieTable.toEntity();
      // assert
      expect(result, tMovie);
    });
  });
}
