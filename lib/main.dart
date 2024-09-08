import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxelo/bloc/weather_bloc_bloc.dart';
import 'package:maxelo/service/weather_service.dart';
import 'package:maxelo/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocProvider<WeatherBlocBloc>(
              create: (context) => WeatherBlocBloc()
                ..add(FetchWeather(snapshot.data as Position)),
              child: const HomeView(),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.deepPurple,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
