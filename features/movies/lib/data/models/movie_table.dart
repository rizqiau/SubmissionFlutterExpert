import 'package:movies/movies.dart';
import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  MovieTable copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
  }) {
    return MovieTable(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
    );
  }

  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
    id: movie.id,
    title: movie.title,
    posterPath: movie.posterPath,
    overview: movie.overview,
  );

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
  };

  Movie toEntity() => Movie.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    title: title,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
