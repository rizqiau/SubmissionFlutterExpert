// ditonton/features/movies/lib/presentation/bloc/movie_detail/movie_detail_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart'; // Untuk rekomendasi
import '../../../domain/entities/movie_detail.dart'; // Untuk detail film

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

// State untuk Detail Film
class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<Movie>
  movieRecommendations; // List rekomendasi, bisa kosong jika tidak ada

  const MovieDetailHasData(this.movieDetail, this.movieRecommendations);

  @override
  List<Object> get props => [movieDetail, movieRecommendations];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}
