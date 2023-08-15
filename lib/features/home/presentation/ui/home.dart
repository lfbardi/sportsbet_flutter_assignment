import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsbet_flutter_assignment/core/design_system/kcolors.dart';
import 'package:sportsbet_flutter_assignment/features/home/presentation/ui/widgets/horizontal_scrollable_list.dart';

import '../../../../core/common/widgets/collapsible_container.dart';
import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../store/home_state.dart';
import '../store/home_store.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    final store = context.read<HomeStore>();

    store.addListener(() {
      if (store.value.status == HomeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ops! Something went wrong.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await store.latestMoviesPolling(timer);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      store.getLatestAndPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeStore = context.watch<HomeStore>();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: kBackgroundColor,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'http://image.tmdb.org/t/p/original/gPbM0MK8CP8A174rmUwGsADNYKD.jpg',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CustomLoadingIndicator(),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: homeStore,
              builder: (context, HomeState state, child) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: CollapsibleSection(
                          title: state.sections[index].title,
                          initiallyExpanded: state.sections[index].isExpanded,
                          onExpansionChanged: (isExpanded) async {
                            if (isExpanded) {
                              if (index == 0) {
                                _timer = Timer.periodic(
                                    const Duration(seconds: 10), (timer) async {
                                  await homeStore.latestMoviesPolling(timer);
                                });
                              }
                              await homeStore.getSectionMovies(index);
                            }
                            if (!isExpanded) {
                              if (index == 0) {
                                _timer.cancel();
                              }
                            }
                            setState(() {
                              state.sections[index].isExpanded = isExpanded;
                            });
                          },
                          children: [
                            if (homeStore.shouldShowLoading(
                                state.sections[index].title,
                                homeStore.value.status)) ...[
                              const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CustomLoadingIndicator(),
                                ),
                              )
                            ],
                            if (state.sections[index].movies.isNotEmpty &&
                                !homeStore.shouldShowLoading(
                                    state.sections[index].title,
                                    homeStore.value.status)) ...[
                              HorizontalScrollableList(
                                movies: state.sections[index].movies,
                                onEndOfPage: () =>
                                    homeStore.getSectionNextPage(index),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                    childCount: state.sections.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
