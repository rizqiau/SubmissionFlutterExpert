import 'package:equatable/equatable.dart';

class Tv extends Equatable {
  Tv({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });

  Tv.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.originalName,
  });

  bool? adult;
  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  int id;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
