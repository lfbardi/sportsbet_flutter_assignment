import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/home_repository.dart';
import 'package:sportsbet_flutter_assignment/features/home/presentation/store/home_state.dart';

import 'home_section.dart';

class HomeStore extends ValueNotifier<HomeState> {
  final HomeRepository repository;

  HomeStore({required this.repository})
      : super(
          HomeState(
            status: HomeStatus.initial,
            sections: [
              HomeSection(
                  title: 'Latest movies', isExpanded: true, currentPage: 1),
              HomeSection(
                  title: 'Popular movies', isExpanded: true, currentPage: 1),
              HomeSection(
                  title: 'Top Rated movies', isExpanded: false, currentPage: 1),
              HomeSection(
                  title: 'Upcoming movies', isExpanded: false, currentPage: 1),
            ],
          ),
        );

  Future getLatestAndPopularMovies() async {
    await getLatestMovies();
    await getPopularMovies();
  }

  getCurrentPageByIndex(int index) {
    return value.sections[index].currentPage;
  }

  latestMoviesPolling(Timer timer) async {
    int lastFetchedPage = value.sections[0].currentPage;
    final latestMoviesEither =
        await repository.getLatestMovies(lastFetchedPage + 1);

    latestMoviesEither.fold((failure) {
      value = value.copyWith(status: HomeStatus.error);
    }, (latestMovies) {
      if (latestMovies.isNotEmpty) {
        value = value.copyWith(
          status: HomeStatus.loadedLatestMovies,
          sections: value.sections.map((section) {
            if (section.title == 'Latest movies') {
              return section.copyWith(
                movies: section.movies + latestMovies,
                currentPage: lastFetchedPage + 1,
              );
            }
            return section;
          }).toList(),
        );
      }
    });
  }

  Future<void> getSectionNextPage(int index) async {
    switch (index) {
      case 0:
        final int nextPage = value.sections[index].currentPage + 1;
        final latestMoviesEither = await repository.getLatestMovies(nextPage);
        latestMoviesEither.fold((failure) {
          value = value.copyWith(status: HomeStatus.error);
        }, (nextPageMovies) {
          value = value.copyWith(
            status: HomeStatus.loadedLatestMovies,
            sections: value.sections.map((section) {
              if (section.title == 'Latest movies') {
                return section.copyWith(
                  movies: section.movies + nextPageMovies,
                  currentPage: nextPage,
                );
              }
              return section;
            }).toList(),
          );
        });
        break;
      case 1:
        final int nextPage = value.sections[index].currentPage + 1;
        final popularMoviesEither = await repository.getPopularMovies(nextPage);
        popularMoviesEither.fold((failure) {
          value = value.copyWith(status: HomeStatus.error);
        }, (nextPageMovies) {
          value = value.copyWith(
            status: HomeStatus.loadedPopularMovies,
            sections: value.sections.map((section) {
              if (section.title == 'Popular movies') {
                return section.copyWith(
                  movies: section.movies + nextPageMovies,
                  currentPage: nextPage,
                );
              }
              return section;
            }).toList(),
          );
        });
        break;
      case 2:
        final int nextPage = value.sections[index].currentPage + 1;
        final topRatedMoviesEither =
            await repository.getTopRatedMovies(nextPage);
        topRatedMoviesEither.fold((failure) {
          value = value.copyWith(status: HomeStatus.error);
        }, (nextPageMovies) {
          value = value.copyWith(
            status: HomeStatus.loadedTopRatedMovies,
            sections: value.sections.map((section) {
              if (section.title == 'Top Rated movies') {
                return section.copyWith(
                  movies: section.movies + nextPageMovies,
                  currentPage: nextPage,
                );
              }
              return section;
            }).toList(),
          );
        });
        break;
      case 3:
        final int nextPage = value.sections[index].currentPage + 1;
        final upcomingMoviesEither =
            await repository.getTopRatedMovies(nextPage);
        upcomingMoviesEither.fold((failure) {
          value = value.copyWith(status: HomeStatus.error);
        }, (nextPageMovies) {
          value = value.copyWith(
            status: HomeStatus.loadedTopRatedMovies,
            sections: value.sections.map((section) {
              if (section.title == 'Top Rated movies') {
                return section.copyWith(
                  movies: section.movies + nextPageMovies,
                  currentPage: nextPage,
                );
              }
              return section;
            }).toList(),
          );
        });
        break;
    }
  }

  Future getSectionMovies(int sectionIndex) async {
    switch (sectionIndex) {
      case 0:
        await getLatestMovies();
        break;
      case 1:
        await getPopularMovies();
        break;
      case 2:
        await getTopRatedMovies();
        break;
      case 3:
        await getUpcomingMovies();
        break;
    }
  }

  shouldShowLoading(String sectionTitle, HomeStatus status) {
    return status == HomeStatus.loadingLatestMovies &&
            sectionTitle == 'Latest movies' ||
        status == HomeStatus.loadingPopularMovies &&
            sectionTitle == 'Popular movies' ||
        status == HomeStatus.loadingTopRatedMovies &&
            sectionTitle == 'Top Rated movies' ||
        status == HomeStatus.loadingUpcomingMovies &&
            sectionTitle == 'Upcoming movies';
  }

  Future<void> getLatestMovies() async {
    value = value.copyWith(status: HomeStatus.loadingLatestMovies);
    final latestMoviesEither =
        await repository.getLatestMovies(value.sections[0].currentPage);

    latestMoviesEither.fold((failure) {
      value = value.copyWith(status: HomeStatus.error);
    }, (latestMovies) {
      value = value.copyWith(
        status: HomeStatus.loadedLatestMovies,
        sections: value.sections.map((section) {
          if (section.title == 'Latest movies') {
            return section.copyWith(movies: latestMovies);
          }
          return section;
        }).toList(),
      );
    });
  }

  Future<void> getPopularMovies() async {
    value = value.copyWith(status: HomeStatus.loadingPopularMovies);
    final popularMoviesEither =
        await repository.getPopularMovies(value.sections[1].currentPage);

    popularMoviesEither.fold((failure) {
      value = value.copyWith(status: HomeStatus.error);
    }, (popularMovies) {
      value = value.copyWith(
        status: HomeStatus.loadedPopularMovies,
        sections: value.sections.map((section) {
          if (section.title == 'Popular movies') {
            return section.copyWith(movies: popularMovies);
          }
          return section;
        }).toList(),
      );
    });
  }

  Future<void> getTopRatedMovies() async {
    value = value.copyWith(status: HomeStatus.loadingTopRatedMovies);
    final topRatedMoviesEither =
        await repository.getTopRatedMovies(value.sections[2].currentPage);

    topRatedMoviesEither.fold((failure) {
      value = value.copyWith(status: HomeStatus.error);
    }, (topRatedMovies) {
      value = value.copyWith(
        status: HomeStatus.loadedTopRatedMovies,
        sections: value.sections.map((section) {
          if (section.title == 'Top Rated movies') {
            return section.copyWith(movies: topRatedMovies);
          }
          return section;
        }).toList(),
      );
    });
  }

  Future<void> getUpcomingMovies() async {
    value = value.copyWith(status: HomeStatus.loadingUpcomingMovies);
    final upcomingMoviesEither =
        await repository.getUpcomingMovies(value.sections[3].currentPage);

    upcomingMoviesEither.fold((failure) {
      value = value.copyWith(status: HomeStatus.error);
    }, (upcomingMovies) {
      value = value.copyWith(
        status: HomeStatus.loadedUpcomingMovies,
        sections: value.sections.map((section) {
          if (section.title == 'Upcoming movies') {
            return section.copyWith(movies: upcomingMovies);
          }
          return section;
        }).toList(),
      );
    });
  }
}
