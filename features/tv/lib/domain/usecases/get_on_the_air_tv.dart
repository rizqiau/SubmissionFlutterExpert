import 'package:dartz/dartz.dart';
import '../entities/tv.dart';
import 'package:core/core.dart';
import '../repositories/tv_repository.dart';

class GetOnTheAirTv {
  final TvRepository repository;

  GetOnTheAirTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTv();
  }
}
