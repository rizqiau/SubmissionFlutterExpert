// ditonton/features/movies/lib/presentation/bloc/search_movies/search_movies_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart'; // Untuk debounce
import 'package:movies/movies.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies _searchMovies;

  SearchMoviesBloc(this._searchMovies) : super(const SearchMoviesInitial()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        if (query.isEmpty) {
          emit(
            const SearchMoviesInitial(),
          ); // Kembali ke initial jika query kosong
          return;
        }

        emit(const SearchMoviesLoading());
        final result = await _searchMovies.execute(query);

        result.fold(
          (failure) {
            emit(SearchMoviesError(failure.message));
          },
          (moviesData) {
            emit(SearchMoviesLoaded(moviesData));
          },
        );
      },
      transformer: debounce(
        const Duration(milliseconds: 500),
      ), // Debounce input
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
