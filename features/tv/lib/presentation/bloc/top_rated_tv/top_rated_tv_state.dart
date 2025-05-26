import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedTvInitial extends TopRatedTvState {
  const TopRatedTvInitial();
}

class TopRatedTvLoading extends TopRatedTvState {
  const TopRatedTvLoading();
}

class TopRatedTvLoaded extends TopRatedTvState {
  final List<Tv> tv;

  const TopRatedTvLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object> get props => [message];
}
