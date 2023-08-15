import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/models/movie.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/data/movie_details_remote_datasource.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/data/movie_details_repository.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/presentation/store/movie_details_store.dart';

import '../../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../movie_details/presentation/ui/movie_details.dart';

class HorizontalScrollableList extends StatefulWidget {
  const HorizontalScrollableList({
    Key? key,
    required this.movies,
    required this.onEndOfPage,
  }) : super(key: key);

  final List<Movie> movies;
  final VoidCallback onEndOfPage;

  @override
  State<HorizontalScrollableList> createState() =>
      _HorizontalScrollableListState();
}

class _HorizontalScrollableListState extends State<HorizontalScrollableList> {
  @override
  Widget build(BuildContext context) {
    final dio = context.read<Dio>();
    return SizedBox(
      height: 150,
      child: LazyLoadScrollView(
        onEndOfPage: widget.onEndOfPage,
        scrollDirection: Axis.horizontal,
        scrollOffset: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      builder: (ctx) {
                        return MultiProvider(
                          providers: [
                            Provider(
                              create: (context) =>
                                  MovieDetailsRemoteDatasourceImpl(
                                dio: dio,
                              ),
                            ),
                            Provider(
                              create: (context) => MovieDetailsRepositoryImpl(
                                datasource: context
                                    .read<MovieDetailsRemoteDatasourceImpl>(),
                              ),
                            ),
                            ChangeNotifierProvider(
                              create: (context) => MovieDetailsStore(
                                repository:
                                    context.read<MovieDetailsRepositoryImpl>(),
                              ),
                            ),
                          ],
                          child: MovieDetails(movieId: widget.movies[index].id),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 110,
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'http://image.tmdb.org/t/p/w342${widget.movies[index].posterPath}',
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
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 80,
                          child: Text(
                            widget.movies[index].title,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
