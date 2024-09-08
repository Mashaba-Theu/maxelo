import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxelo/bloc/weather_bloc_bloc.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget getWeatherCode(int code) {
    final now = DateTime.now();
    final hour = now.hour;

    String timeOfDay;
    if (hour >= 6 && hour < 18) {
      timeOfDay = 'day';
    } else {
      timeOfDay = 'night';
    }

    String imagePath;
    if (code > 200 && code <= 300) {
      imagePath = 'assets/images/thunderstorm.png';
    } else if (code > 300 && code <= 400) {
      imagePath = 'assets/images/drizzle.png';
    } else if (code > 400 && code <= 500) {
      imagePath = 'assets/images/rain.png';
    } else if (code > 500 && code <= 600) {
      imagePath = 'assets/images/showers.png';
    } else if (code > 600 && code <= 700) {
      imagePath = 'assets/images/snow.png';
    } else if (code > 700 && code < 800) {
      imagePath = 'assets/images/mist.png';
    } else if (code == 800) {
      imagePath = 'assets/images/clear.png';
    } else if (code > 800 && code < 900) {
      imagePath = 'assets/images/clouds.png';
    } else {
      imagePath = 'assets/images/thunderstorm.png';
    }
    if (timeOfDay == 'day') {
      imagePath = imagePath.replaceAll('.png', '_day.png');
    } else if (timeOfDay == 'night') {
      imagePath = imagePath.replaceAll('.png', '_night.png');
    }

    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset(
        imagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(3, 0.0),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-3, 0.0),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, -1.2),
            child: Container(
              height: 400,
              width: 600,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 114, 6, 255),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
            builder: (context, state) {
              if (state is WeatherBlocSuccess) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          state.weather.areaName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        getWeatherCode(state.weather.weatherConditionCode!),
                        const SizedBox(height: 20),
                        Text(
                          ' ${state.weather.temperature!.celsius!.round()}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          state.weather.weatherMain!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm EEEE dd MMM')
                              .format(state.weather.date!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Min',
                                        style: TextStyle(color: Colors.white)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${state.weather.tempMin!.celsius!.round()}°C',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Image.asset("assets/images/low-temp.png",
                                    scale: 8),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset("assets/images/high-temp.png",
                                    scale: 8),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Max',
                                        style: TextStyle(color: Colors.white)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${state.weather.tempMax!.celsius!.round()}°C',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
        ],
      ),
    );
  }
}
