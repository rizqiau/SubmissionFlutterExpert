import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;
  final GetTvRecommendations _getTvRecommendations;

  TvDetailBloc({
    required GetTvDetail getTvDetail,
    required GetTvRecommendations getTvRecommendations,
  }) : _getTvDetail = getTvDetail,
       _getTvRecommendations = getTvRecommendations,
       super(const TvDetailInitial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(const TvDetailLoading());

      final detailResult = await _getTvDetail.execute(event.id);

      TvDetail? tvDetail;
      String? errorMessage;

      detailResult.fold(
        (failure) {
          errorMessage = failure.message;
        },
        (data) {
          tvDetail = data;
        },
      );

      if (errorMessage != null) {
        emit(TvDetailError(errorMessage!));
        return;
      }

      List<Tv> recommendations = [];
      final recommendationsResult = await _getTvRecommendations.execute(
        event.id,
      );

      recommendationsResult.fold((failure) {}, (data) {
        recommendations = data;
      });

      if (tvDetail != null) {
        emit(TvDetailHasData(tvDetail!, recommendations));
      } else {
        emit(const TvDetailError('Failed to load Tv detail.'));
      }
    });
  }
}
