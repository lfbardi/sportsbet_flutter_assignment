import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsbet_flutter_assignment/core/common/widgets/custom_loading_indicator.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/presentation/store/movie_details_state.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/presentation/store/movie_details_store.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.movieId});

  final int movieId;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    super.initState();

    final store = context.read<MovieDetailsStore>();

    store.addListener(() {
      if (store.value.status == MovieDetailsStatus.error) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ops! Something went wrong.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      store.getMovieDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieDetailsStore = context.watch<MovieDetailsStore>();

    return ValueListenableBuilder(
      valueListenable: movieDetailsStore,
      builder: (context, MovieDetailsState state, child) {
        switch (state.status) {
          case MovieDetailsStatus.initial:
          case MovieDetailsStatus.loading:
            return const Center(
              child: CustomLoadingIndicator(),
            );
          case MovieDetailsStatus.error:
            return const SizedBox.shrink();
          case MovieDetailsStatus.success:
            return Scaffold(
              body: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: ColoredBox(
                            color: Colors.grey,
                            child: SizedBox(height: 4, width: 50),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 160,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  'http://image.tmdb.org/t/p/w342${state.movie!.posterPath}',
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CustomLoadingIndicator(),
                                    );
                                  },
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.movie!.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.movie!.overview,
                                    softWrap: true,
                                    maxLines: 10,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'TMDB Score: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.movie!.voteAverage.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.yellow),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Release date: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.movie!.releaseDate.replaceAll('-', '/'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Genres: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                state.movie!.genres.join(', '),
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        state.movie!.videoName != ''
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Video Name: ${state.movie!.videoName}',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: const Icon(Icons.play_arrow, size: 50),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
