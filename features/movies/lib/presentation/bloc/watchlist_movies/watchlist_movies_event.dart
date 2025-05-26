import 'package:equatable/equatable.dart';
import 'package:movies/movies.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends WatchlistMoviesEvent {
  const FetchWatchlistMovies();

  @override
  List<Object> get props => [];
}

// Event untuk mengecek status watchlist
class LoadWatchlistStatus extends WatchlistMoviesEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

// Event untuk menambahkan ke watchlist
class AddWatchlistMovie extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  const AddWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

// Event untuk menghapus dari watchlist
class RemoveWatchlistMovie extends WatchlistMoviesEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}
