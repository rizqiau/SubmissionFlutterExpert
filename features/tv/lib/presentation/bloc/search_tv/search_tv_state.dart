import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

class SearchTvInitial extends SearchTvState {
  const SearchTvInitial();
}

class SearchTvLoading extends SearchTvState {
  const SearchTvLoading();
}

class SearchTvLoaded extends SearchTvState {
  final List<Tv> result;

  const SearchTvLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class SearchTvError extends SearchTvState {
  final String message;

  const SearchTvError(this.message);

  @override
  List<Object> get props => [message];
}
