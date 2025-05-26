import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvInitial extends WatchlistTvState {
  const WatchlistTvInitial();
}

class WatchlistTvLoading extends WatchlistTvState {
  const WatchlistTvLoading();
}

class WatchlistTvLoaded extends WatchlistTvState {
  final List<Tv> watchlistTv;

  const WatchlistTvLoaded(this.watchlistTv);

  @override
  List<Object> get props => [watchlistTv];
}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistStatusLoaded extends WatchlistTvState {
  final bool isAddedToWatchlist;

  const WatchlistStatusLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistMessage extends WatchlistTvState {
  final String message;

  const WatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}
