import 'package:dartz/dartz.dart';
import '../entities/tv.dart';
import 'package:core/core.dart';
import '../repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
