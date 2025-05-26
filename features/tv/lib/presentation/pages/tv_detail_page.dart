import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Mengirim event untuk mengambil detail TV dan rekomendasi
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      // Mengirim event untuk memuat status watchlist
      context.read<WatchlistTvBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WatchlistTvBloc, WatchlistTvState>(
        listener: (context, watchlistState) {
          // Mendengarkan perubahan state WatchlistTvBloc untuk menampilkan pesan
          if (watchlistState is WatchlistMessage) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(watchlistState.message)));
          } else if (watchlistState is WatchlistTvError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text(watchlistState.message));
              },
            );
          }
        },
        builder: (context, watchlistState) {
          // BlocBuilder untuk TvDetailBloc
          return BlocBuilder<TvDetailBloc, TvDetailState>(
            builder: (context, tvDetailState) {
              if (tvDetailState is TvDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (tvDetailState is TvDetailHasData) {
                final tv = tvDetailState.tvDetail;
                final recommendations = tvDetailState.tvRecommendations;

                // Menentukan status isAddedToWatchlist dari WatchlistTvBloc
                bool isAddedToWatchlist = false;
                if (watchlistState is WatchlistStatusLoaded) {
                  isAddedToWatchlist = watchlistState.isAddedToWatchlist;
                }
                // Jika ada pesan sukses penambahan/penghapusan, perbarui status
                else if (watchlistState is WatchlistMessage) {
                  isAddedToWatchlist =
                      watchlistState.message ==
                      WatchlistTvBloc.watchlistAddSuccessMessage;
                }

                return SafeArea(
                  child: DetailContent(tv, recommendations, isAddedToWatchlist),
                );
              } else if (tvDetailState is TvDetailError) {
                return Center(child: Text(tvDetailState.message));
              } else {
                // State awal atau tidak terduga
                return const Center(child: Text('Failed to load Tv detail.'));
              }
            },
          );
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder:
              (context, url) =>
                  const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(tv.name, style: kHeading5),
                      const SizedBox(height: 8),
                      Text(
                        tv.originalName != tv.name
                            ? 'Original Title: ${tv.originalName}'
                            : '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              tv.status,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              tv.type,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          const SizedBox(width: 8),
                          if (tv.adult)
                            Chip(
                              label: const Text(
                                '18+',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'First Air: ${tv.firstAirDate}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last Air: ${tv.lastAirDate}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.language,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Languages: ${tv.languages.join(', ')}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.flag,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Country: ${tv.originCountry.join(', ')}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Episode Runtime: ${_showDurations(tv.episodeRunTime)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.confirmation_number,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Seasons: ${tv.numberOfSeasons}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.confirmation_number_outlined,
                            size: 18,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Episodes: ${tv.numberOfEpisodes}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Genres: ${_showGenres(tv.genres)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: tv.voteAverage / 2,
                            itemCount: 5,
                            itemBuilder:
                                (context, index) => const Icon(
                                  Icons.star,
                                  color: kMikadoYellow,
                                ),
                            itemSize: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tv.voteAverage} (${tv.voteCount} votes)',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          if (!isAddedWatchlist) {
                            context.read<WatchlistTvBloc>().add(
                              AddWatchlist(tv),
                            );
                          } else {
                            context.read<WatchlistTvBloc>().add(
                              RemoveWatchlistTvs(tv),
                            );
                          }
                          // Pesan akan ditangani oleh BlocConsumer di TvDetailPage
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isAddedWatchlist
                                ? const Icon(Icons.check)
                                : const Icon(Icons.add),
                            const SizedBox(width: 4),
                            const Text('Watchlist'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Overview', style: kHeading6),
                      const SizedBox(height: 4),
                      Text(
                        tv.overview,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Popularity: ${tv.popularity}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Text('Recommendations', style: kHeading6),
                      const SizedBox(height: 8),
                      // Langsung menggunakan data rekomendasi yang diterima dari TvDetailPage
                      recommendations.isEmpty
                          ? const Text('No recommendations found')
                          : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendations.length,
                              itemBuilder: (context, index) {
                                final tvItem = recommendations[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigasi ke detail TV baru dengan ID yang berbeda
                                      Navigator.pushReplacementNamed(
                                        context,
                                        TvDetailPage.ROUTE_NAME,
                                        arguments: tvItem.id,
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${tvItem.posterPath}',
                                        width: 100,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                                const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 16,
          left: 8,
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((g) => g.name).join(', ');
  }

  String _showDurations(List<int> runtimes) {
    if (runtimes.isEmpty) return '-';
    return runtimes
        .map((rt) {
          final h = rt ~/ 60;
          final m = rt % 60;
          if (h > 0) return '${h}h ${m}m';
          return '${m}m';
        })
        .join(', ');
  }
}
