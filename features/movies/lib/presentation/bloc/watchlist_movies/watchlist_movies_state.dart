// ditonton/features/movies/lib/presentation/bloc/watchlist_movies/watchlist_movies_state.dart
import 'package:equatable/equatable.dart';
import 'package:movies/movies.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

// State untuk daftar watchlist
class WatchlistMoviesInitial extends WatchlistMoviesState {
  const WatchlistMoviesInitial();
}

class WatchlistMoviesLoading extends WatchlistMoviesState {
  const WatchlistMoviesLoading();
}

class WatchlistMoviesLoaded extends WatchlistMoviesState {
  final List<Movie> watchlistMovies;

  const WatchlistMoviesLoaded(this.watchlistMovies);

  @override
  List<Object> get props => [watchlistMovies];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

// State untuk status watchlist (apakah ada di watchlist atau tidak)
class WatchlistStatusLoaded extends WatchlistMoviesState {
  final bool isAddedToWatchlist;

  const WatchlistStatusLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

// State untuk hasil pesan penambahan/penghapusan watchlist
class WatchlistMessage extends WatchlistMoviesState {
  final String message;

  const WatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}
