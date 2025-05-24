import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTopRatedTv {
  final TvRepository repository;

  GetTopRatedTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}
