import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveWatchlistTv(tv);
  }
}
