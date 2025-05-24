import 'package:dartz/dartz.dart';
import '../entities/tv.dart';
import 'package:core/core.dart';
import '../repositories/tv_repository.dart';

class GetWatchlistTv {
  final TvRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTv();
  }
}
