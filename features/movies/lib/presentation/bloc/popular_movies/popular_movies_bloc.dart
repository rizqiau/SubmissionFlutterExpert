import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies)
      : super(const PopularMoviesInitial()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(const PopularMoviesLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMoviesError(failure.message));
        },
        (moviesData) {
          emit(PopularMoviesLoaded(moviesData));
        },
      );
    });
  }
}
