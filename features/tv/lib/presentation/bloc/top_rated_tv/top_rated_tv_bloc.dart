import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(const TopRatedTvInitial()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(const TopRatedTvLoading());
      final result = await _getTopRatedTv.execute();

      result.fold(
        (failure) {
          emit(TopRatedTvError(failure.message));
        },
        (moviesData) {
          emit(TopRatedTvLoaded(moviesData));
        },
      );
    });
  }
}
