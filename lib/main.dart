import 'package:fic11_starter_pos/core/constants/colors.dart';
import 'package:fic11_starter_pos/data/datasource/auth_local_datasource.dart';
import 'package:fic11_starter_pos/data/datasource/auth_remote_datasource.dart';
import 'package:fic11_starter_pos/data/datasource/product_remote_datasource.dart';
import 'package:fic11_starter_pos/presentation/auth/bloc/login/login_bloc.dart';
import 'package:fic11_starter_pos/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:fic11_starter_pos/presentation/auth/bloc/product/product_bloc.dart';
import 'package:fic11_starter_pos/presentation/auth/pages/login_page.dart';
import 'package:fic11_starter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource())
            ..add(const ProductEvent.fetchLocal()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter FIC Batch 11',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
            future: AuthLocalDataSource().isAuth(),
            builder: (context, snapshoot) {
              if (snapshoot.hasData && snapshoot.data == true) {
                return const DashboardPage();
              } else {
                return const LoginPage();
              }
            }),
      ),
    );
  }
}
