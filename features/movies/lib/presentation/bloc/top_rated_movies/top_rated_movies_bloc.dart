import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies)
      : super(const TopRatedMoviesInitial()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(const TopRatedMoviesLoading());
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedMoviesError(failure.message));
        },
        (moviesData) {
          emit(TopRatedMoviesLoaded(moviesData));
        },
      );
    });
  }
}
