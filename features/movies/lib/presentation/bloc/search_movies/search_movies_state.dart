import 'package:equatable/equatable.dart';
import 'package:movies/movies.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object> get props => [];
}

class SearchMoviesInitial extends SearchMoviesState {
  const SearchMoviesInitial();
}

class SearchMoviesLoading extends SearchMoviesState {
  const SearchMoviesLoading();
}

class SearchMoviesLoaded extends SearchMoviesState {
  final List<Movie> result;

  const SearchMoviesLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class SearchMoviesError extends SearchMoviesState {
  final String message;

  const SearchMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
