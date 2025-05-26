// ditonton/features/movies/lib/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;
  final GetWatchListStatusTv _getWatchListStatus;
  final SaveWatchlistTv _saveWatchlist;
  final RemoveWatchlistTv _removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistTvBloc({
    required GetWatchlistTv getWatchlistTv,
    required GetWatchListStatusTv getWatchListStatus,
    required SaveWatchlistTv saveWatchlist,
    required RemoveWatchlistTv removeWatchlist,
  }) : _getWatchlistTv = getWatchlistTv,
       _getWatchListStatus = getWatchListStatus,
       _saveWatchlist = saveWatchlist,
       _removeWatchlist = removeWatchlist,
       super(const WatchlistTvInitial()) {
    // Event: Fetch Watchlist Tv
    on<FetchWatchlistTv>((event, emit) async {
      emit(const WatchlistTvLoading());
      final result = await _getWatchlistTv.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (moviesData) {
          emit(WatchlistTvLoaded(moviesData));
        },
      );
    });

    // Event: Load Watchlist Status (untuk Tv Detail Page)
    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);
      emit(WatchlistStatusLoaded(result));
    });

    // Event: Add Watchlist Tv (untuk Tv Detail Page)
    on<AddWatchlist>((event, emit) async {
      final movieDetail = event.tvDetail;
      final result = await _saveWatchlist.execute(movieDetail);

      result.fold(
        (failure) {
          emit(
            WatchlistTvError(failure.message),
          ); // Menggunakan WatchlistTvError untuk pesan error
        },
        (successMessage) {
          emit(const WatchlistMessage(watchlistAddSuccessMessage));
        },
      );
    });

    // Event: Remove Watchlist Tv (untuk Tv Detail Page)
    on<RemoveWatchlistTvs>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await _removeWatchlist.execute(tvDetail);

      result.fold(
        (failure) {
          emit(
            WatchlistTvError(failure.message),
          ); // Menggunakan WatchlistTvError untuk pesan error
        },
        (successMessage) {
          emit(const WatchlistMessage(watchlistRemoveSuccessMessage));
        },
      );
    });
  }
}
