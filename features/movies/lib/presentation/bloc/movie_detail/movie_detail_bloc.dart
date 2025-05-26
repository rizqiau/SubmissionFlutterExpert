// ditonton/features/movies/lib/presentation/bloc/movie_detail/movie_detail_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;

  MovieDetailBloc({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
  })  : _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        super(const MovieDetailInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(const MovieDetailLoading()); // Tunjukkan loading awal

      final detailResult = await _getMovieDetail.execute(event.id);

      MovieDetail? movieDetail;
      String? errorMessage;

      detailResult.fold(
        (failure) {
          errorMessage = failure.message;
        },
        (data) {
          movieDetail = data;
        },
      );

      // Jika gagal memuat detail film, langsung emit error dan keluar
      if (errorMessage != null) {
        emit(MovieDetailError(errorMessage!));
        return;
      }

      // Jika detail film berhasil dimuat, lanjutkan untuk memuat rekomendasi
      // Rekomendasi akan dimulai dengan list kosong
      List<Movie> recommendations = [];
      final recommendationsResult = await _getMovieRecommendations.execute(
        event.id,
      );

      recommendationsResult.fold(
        (failure) {
          // Jika rekomendasi gagal, kita bisa memilih untuk:
          // 1. Mengabaikan dan tetap menampilkan detail film tanpa rekomendasi (seperti ini)
          // 2. Emit error terpisah untuk rekomendasi (membutuhkan state yang lebih kompleks)
          // 3. Menambahkan pesan error rekomendasi ke state MovieDetailHasData (membutuhkan modifikasi state)
          // Untuk saat ini, kita biarkan saja list rekomendasi kosong jika gagal.
        },
        (data) {
          recommendations = data;
        },
      );

      // Emit state akhir yang berisi detail film dan list rekomendasi (bisa kosong)
      if (movieDetail != null) {
        emit(MovieDetailHasData(movieDetail!, recommendations));
      } else {
        // Ini seharusnya tidak tercapai jika detailResult sukses,
        // namun sebagai fallback untuk kasus tak terduga.
        emit(const MovieDetailError('Failed to load movie detail.'));
      }
    });
  }
}
