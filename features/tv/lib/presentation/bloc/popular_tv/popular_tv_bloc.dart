import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(const PopularTvInitial()) {
    on<FetchPopularTv>((event, emit) async {
      emit(const PopularTvLoading());
      final result = await _getPopularTv.execute();

      result.fold(
        (failure) {
          emit(PopularTvError(failure.message));
        },
        (moviesData) {
          emit(PopularTvLoaded(moviesData));
        },
      );
    });
  }
}
