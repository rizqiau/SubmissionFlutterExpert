import '../../../lib/data/models/tv_table.dart';
import '../../../lib/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../movies/test/dummy_data/dummy_objects.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    originalName: 'originalName',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTv = Tv.watchlist(
    id: 1,
    originalName: 'originalName',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('fromEntity', () {
    test('should return a valid model from TvDetail entity', () async {
      // act
      final result = TvTable.fromEntity(testTvDetail);
      // assert
      expect(result, tTvTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        'id': 1,
        'originalName': 'originalName',
        'posterPath': 'posterPath',
        'overview': 'overview',
      };
      // act
      final result = tTvTable.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should return a valid Tv entity', () async {
      // act
      final result = tTvTable.toEntity();
      // assert
      expect(result, tTv);
    });
  });
}
