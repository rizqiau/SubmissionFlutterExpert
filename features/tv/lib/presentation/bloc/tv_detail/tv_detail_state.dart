import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailInitial extends TvDetailState {
  const TvDetailInitial();
}

class TvDetailLoading extends TvDetailState {
  const TvDetailLoading();
}

class TvDetailHasData extends TvDetailState {
  final TvDetail tvDetail;
  final List<Tv> tvRecommendations;

  const TvDetailHasData(this.tvDetail, this.tvRecommendations);

  @override
  List<Object> get props => [tvDetail, tvRecommendations];
}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}
