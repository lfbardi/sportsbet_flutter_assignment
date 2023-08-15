import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/home_remote_datasource.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/home_repository.dart';
import 'package:sportsbet_flutter_assignment/features/home/presentation/ui/home.dart';

import 'features/home/presentation/store/home_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        dividerColor: Colors.transparent,
      ),
      home: MultiProvider(
        providers: [
          Provider<Dio>(
            create: (_) => Dio(
              BaseOptions(
                baseUrl: 'https://api.themoviedb.org/3',
                headers: {
                  'Authorization':
                      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkOTFiOGU4N2JjYmY5YzJjOGRiZGFkMTg5ODRhNjkwYiIsInN1YiI6IjY0ZDk0YTA2MDAxYmJkMDBjNmM3Y2ZjMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XtuGrk9T2_iEsDJ1z3IgQ6BjyFuIccsV0K7G8ECjyn8'
                },
              ),
            ),
          ),
          Provider(
            create: (context) => HomeRemoteDatasourceImpl(
              dio: context.read<Dio>(),
            ),
          ),
          Provider(
            create: (context) => HomeRepositoryImpl(
              datasource: context.read<HomeRemoteDatasourceImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeStore(
              repository: context.read<HomeRepositoryImpl>(),
            ),
          ),
        ],
        builder: (context, child) {
          return const Home();
        },
      ),
    );
  }
}
