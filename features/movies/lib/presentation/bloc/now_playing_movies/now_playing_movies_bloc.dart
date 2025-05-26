import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(const NowPlayingMoviesInitial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(const NowPlayingMoviesLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingMoviesError(failure.message));
        },
        (moviesData) {
          emit(NowPlayingMoviesLoaded(moviesData));
        },
      );
    });
  }
}
