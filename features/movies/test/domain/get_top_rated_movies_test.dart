import 'package:dartz/dartz.dart';
import '../../lib/domain/entities/movie.dart';
import '../../lib/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test('should get list of movies from repository', () async {
    // arrange
    when(
      mockMovieRepository.getTopRatedMovies(),
    ).thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
