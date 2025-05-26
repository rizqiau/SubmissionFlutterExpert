// ditonton/features/movies/lib/presentation/bloc/popular_movies/popular_movies_event.dart
import 'package:equatable/equatable.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends PopularMoviesEvent {
  const FetchPopularMovies();

  @override
  List<Object> get props => [];
}
