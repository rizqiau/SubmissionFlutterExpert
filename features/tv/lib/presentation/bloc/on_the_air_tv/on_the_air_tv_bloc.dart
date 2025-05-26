import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTv _getOnTheAirTv;

  OnTheAirTvBloc(this._getOnTheAirTv) : super(const OnTheAirTvInitial()) {
    on<FetchOnTheAirTv>((event, emit) async {
      emit(const OnTheAirTvLoading());
      final result = await _getOnTheAirTv.execute();

      result.fold(
        (failure) {
          emit(OnTheAirTvError(failure.message));
        },
        (moviesData) {
          emit(OnTheAirTvLoaded(moviesData));
        },
      );
    });
  }
}
