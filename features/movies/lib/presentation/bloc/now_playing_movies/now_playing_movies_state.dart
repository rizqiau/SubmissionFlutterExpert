import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class NowPlayingMoviesInitial extends NowPlayingMoviesState {
  const NowPlayingMoviesInitial();
}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {
  const NowPlayingMoviesLoading();
}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;

  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  const NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
