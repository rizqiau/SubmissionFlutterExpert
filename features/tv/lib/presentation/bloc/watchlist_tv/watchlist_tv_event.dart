import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTv extends WatchlistTvEvent {
  const FetchWatchlistTv();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends WatchlistTvEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends WatchlistTvEvent {
  final TvDetail tvDetail;

  const AddWatchlist(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

class RemoveWatchlistTvs extends WatchlistTvEvent {
  final TvDetail tvDetail;

  const RemoveWatchlistTvs(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}
