import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {"id": 1, "name": "Action"};
      // act
      final result = tGenreModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
