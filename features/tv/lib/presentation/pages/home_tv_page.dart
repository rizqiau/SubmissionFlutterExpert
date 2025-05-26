import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-home';
  const HomeTvPage({super.key});

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirTvBloc>().add(const FetchOnTheAirTv());
      context.read<PopularTvBloc>().add(const FetchPopularTv());
      context.read<TopRatedTvBloc>().add(const FetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
            key: const Key('search_button'),
            onPressed: () {
              Navigator.pushNamed(context, TvSearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<OnTheAirTvBloc, OnTheAirTvState>(
                builder: (context, state) {
                  if (state is OnTheAirTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OnTheAirTvLoaded) {
                    return TvList(state.tv);
                  } else if (state is OnTheAirTvError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed to load on the air tv series');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap:
                    () =>
                        Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
                key: const Key('see_more_popular'),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                builder: (context, state) {
                  if (state is PopularTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PopularTvLoaded) {
                    return TvList(state.tv);
                  } else if (state is PopularTvError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed to load popular tv series');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap:
                    () =>
                        Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
                key: const Key('see_more_top_rated'),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
                  if (state is TopRatedTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTvLoaded) {
                    return TvList(state.tv);
                  } else if (state is TopRatedTvError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed to load top rated tv series');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({
    required String title,
    required Function() onTap,
    Key? key,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          key: key,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  TvList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
