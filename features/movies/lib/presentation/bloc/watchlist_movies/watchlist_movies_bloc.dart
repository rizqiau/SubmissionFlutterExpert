// ditonton/features/movies/lib/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistMoviesBloc({
    required GetWatchlistMovies getWatchlistMovies,
    required GetWatchListStatus getWatchListStatus,
    required SaveWatchlist saveWatchlist,
    required RemoveWatchlist removeWatchlist,
  })  : _getWatchlistMovies = getWatchlistMovies,
        _getWatchListStatus = getWatchListStatus,
        _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        super(const WatchlistMoviesInitial()) {
    // Event: Fetch Watchlist Movies
    on<FetchWatchlistMovies>((event, emit) async {
      emit(const WatchlistMoviesLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMoviesError(failure.message));
        },
        (moviesData) {
          emit(WatchlistMoviesLoaded(moviesData));
        },
      );
    });

    // Event: Load Watchlist Status (untuk Movie Detail Page)
    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);
      emit(WatchlistStatusLoaded(result));
    });

    // Event: Add Watchlist Movie (untuk Movie Detail Page)
    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _saveWatchlist.execute(movieDetail);

      result.fold(
        (failure) {
          emit(
            WatchlistMoviesError(failure.message),
          ); // Menggunakan WatchlistMoviesError untuk pesan error
        },
        (successMessage) {
          emit(const WatchlistMessage(watchlistAddSuccessMessage));
        },
      );
    });

    // Event: Remove Watchlist Movie (untuk Movie Detail Page)
    on<RemoveWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _removeWatchlist.execute(movieDetail);

      result.fold(
        (failure) {
          emit(
            WatchlistMoviesError(failure.message),
          ); // Menggunakan WatchlistMoviesError untuk pesan error
        },
        (successMessage) {
          emit(const WatchlistMessage(watchlistRemoveSuccessMessage));
        },
      );
    });
  }
}
