import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LocationCubit>(
      create: (context) => LocationCubit()..getLocation(),),
      BlocProvider<BirdPostCubit>(create: (context) => BirdPostCubit(),)
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF90AACB),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ),
          ),
        home: MapScreen(),
      ),
    );
  }
}