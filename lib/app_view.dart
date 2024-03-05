import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_delivery_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:pizza_delivery_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizza_delivery_app/screens/auth/views/welcome_screen.dart';
import 'package:pizza_delivery_app/screens/home/blocs/get_pizza/get_pizza_bloc.dart';
import 'package:pizza_delivery_app/screens/home/views/home_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Pizza Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.grey.shade200, elevation: 0),
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade200,
          onBackground: Colors.black,
          primary: Colors.blue,
          onPrimary: Colors.black,
          secondary: Colors.grey,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                      context.read<AuthenticationBloc>().userRepository),
                ),
                BlocProvider(
                  create: (context) =>
                      GetPizzaBloc(FirebasePizzaRepo())..add(GetPizza()),
                ),
              ],
              child: const HomeScreen(),
            );
          } else if (state.status == AuthenticationStatus.unknown) {
            return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: const Center(child: CircularProgressIndicator()));
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
