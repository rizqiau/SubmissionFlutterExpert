import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvInitial extends OnTheAirTvState {
  const OnTheAirTvInitial();
}

class OnTheAirTvLoading extends OnTheAirTvState {
  const OnTheAirTvLoading();
}

class OnTheAirTvLoaded extends OnTheAirTvState {
  final List<Tv> tv;

  const OnTheAirTvLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnTheAirTvError extends OnTheAirTvState {
  final String message;

  const OnTheAirTvError(this.message);

  @override
  List<Object> get props => [message];
}
