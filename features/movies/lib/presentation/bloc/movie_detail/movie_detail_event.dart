// ditonton/features/movies/lib/presentation/bloc/movie_detail/movie_detail_event.dart
import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchMovieRecommendations extends MovieDetailEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
