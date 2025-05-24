import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).fetchTvDetail(widget.id);
      Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Center(child: Text(provider.message));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder:
              (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
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
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(tv.name, style: kHeading5),
                      SizedBox(height: 8),
                      Text(
                        tv.originalName != tv.name
                            ? 'Original Title: ${tv.originalName}'
                            : '',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              tv.status,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blueGrey,
                          ),
                          SizedBox(width: 8),
                          Chip(
                            label: Text(
                              tv.type,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          SizedBox(width: 8),
                          if (tv.adult)
                            Chip(
                              label: Text(
                                '18+',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.white54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'First Air: ${tv.firstAirDate}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Colors.white54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Last Air: ${tv.lastAirDate}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.language, size: 18, color: Colors.white54),
                          SizedBox(width: 4),
                          Text(
                            'Languages: ${tv.languages.join(', ')}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.flag, size: 18, color: Colors.white54),
                          SizedBox(width: 4),
                          Text(
                            'Country: ${tv.originCountry.join(', ')}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 18, color: Colors.white54),
                          SizedBox(width: 4),
                          Text(
                            'Episode Runtime: ${_showDurations(tv.episodeRunTime)}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            size: 18,
                            color: Colors.white54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Seasons: ${tv.numberOfSeasons}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 18,
                            color: Colors.white54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Episodes: ${tv.numberOfEpisodes}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Genres: ${_showGenres(tv.genres)}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: tv.voteAverage / 2,
                            itemCount: 5,
                            itemBuilder:
                                (context, index) =>
                                    Icon(Icons.star, color: kMikadoYellow),
                            itemSize: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${tv.voteAverage} (${tv.voteCount} votes)',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          if (!isAddedWatchlist) {
                            await Provider.of<TvDetailNotifier>(
                              context,
                              listen: false,
                            ).addWatchlist(tv);
                          } else {
                            await Provider.of<TvDetailNotifier>(
                              context,
                              listen: false,
                            ).removeFromWatchlist(tv);
                          }
                          final message =
                              Provider.of<TvDetailNotifier>(
                                context,
                                listen: false,
                              ).watchlistMessage;
                          if (message ==
                                  TvDetailNotifier.watchlistAddSuccessMessage ||
                              message ==
                                  TvDetailNotifier
                                      .watchlistRemoveSuccessMessage) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(content: Text(message));
                              },
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isAddedWatchlist
                                ? Icon(Icons.check)
                                : Icon(Icons.add),
                            SizedBox(width: 4),
                            Text('Watchlist'),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Overview', style: kHeading6),
                      SizedBox(height: 4),
                      Text(tv.overview, style: TextStyle(color: Colors.white)),
                      SizedBox(height: 16),
                      Text(
                        'Popularity: ${tv.popularity}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      Text('Recommendations', style: kHeading6),
                      SizedBox(height: 8),
                      Consumer<TvDetailNotifier>(
                        builder: (context, data, child) {
                          if (data.recommendationState ==
                              RequestState.Loading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (data.recommendationState ==
                              RequestState.Error) {
                            return Text(data.message);
                          } else if (data.recommendationState ==
                              RequestState.Loaded) {
                            return Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recommendations.length,
                                itemBuilder: (context, index) {
                                  final tv = recommendations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          TvDetailPage.ROUTE_NAME,
                                          arguments: tv.id,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                          width: 100,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(height: 24),
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
              icon: Icon(Icons.arrow_back),
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
