import 'package:dartz/dartz.dart';
import '../../lib/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test/dummy_data/dummy_objects.dart';
import '../../test/helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getWatchlistMovies(),
    ).thenAnswer((_) async => Right(testMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testMovieList));
  });
}
