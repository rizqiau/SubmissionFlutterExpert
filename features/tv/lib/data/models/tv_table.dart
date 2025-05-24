import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  final int id;
  final String? originalName;
  final String? posterPath;
  final String? overview;

  TvTable({
    required this.id,
    required this.originalName,
    required this.posterPath,
    required this.overview,
  });

  TvTable copyWith({
    int? id,
    String? originalName,
    String? overview,
    String? posterPath,
  }) {
    return TvTable(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
    );
  }

  factory TvTable.fromEntity(TvDetail tv) => TvTable(
    id: tv.id,
    originalName: tv.originalName,
    posterPath: tv.posterPath,
    overview: tv.overview,
  );

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
    id: map['id'],
    originalName: map['originalName'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'originalName': originalName,
    'posterPath': posterPath,
    'overview': overview,
  };

  Tv toEntity() => Tv.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    originalName: originalName,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, originalName, posterPath, overview];
}
