import 'package:fic11_starter_pos/core/constants/colors.dart';
import 'package:fic11_starter_pos/core/extensions/build_context_ext.dart';
import 'package:fic11_starter_pos/data/datasource/auth_local_datasource.dart';
import 'package:fic11_starter_pos/data/datasource/product_local_datasource.dart';
import 'package:fic11_starter_pos/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:fic11_starter_pos/presentation/auth/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../auth/bloc/product/product_bloc.dart';
import 'manage_printer_page.dart';

class ManageMenuPage extends StatefulWidget {
  const ManageMenuPage({super.key});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                state.maybeMap(
                    orElse: () {},
                    success: (_) async {
                      await ProductLocalDatasource.instance.removeAllProduct();
                      await ProductLocalDatasource.instance
                          .insertAllProduct(_.product.toList());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text(
                            'Sync data success',
                          )));
                    });
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return ElevatedButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(const ProductEvent.fetch());
                        },
                        child: const Text('Sync Data'));
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
            const Divider(),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                state.maybeMap(
                  orElse: () {},
                  success: (_) {
                    AuthLocalDataSource().removeAuthData();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                );
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<LogoutBloc>().add(const LogoutEvent.logout());
                  },
                  child: const Text('Logout'),
                );
              },
            ),
            const Divider(),
          ],
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Kelola'),
    //     centerTitle: true,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(32.0),
    //     child: Column(
    //       children: [
    //         // Row(
    //         //   children: [
    //         //     MenuButton(
    //         //       iconPath: Assets.images.manageProduct.path,
    //         //       label: 'Kelola Produk',
    //         //       onPressed: () {},
    //         //       isImage: true,
    //         //     ),
    //         //     const SpaceWidth(15.0),
    //         //     MenuButton(
    //         //       iconPath: Assets.images.managePrinter.path,
    //         //       label: 'Kelola Printer',
    //         //       onPressed: () => context.push(const ManagePrinterPage()),
    //         //       isImage: true,
    //         //     ),
    //         //   ],
    //         // ),
    //         // const Divider(),
    //         BlocConsumer<ProductBloc, ProductState>(
    //           listener: (context, state) {
    //             state.maybeMap(
    //                 orElse: () {},
    //                 success: (_) async {
    //                   await ProductLocalDatasource.instance.removeAllProduct();
    //                   await ProductLocalDatasource.instance
    //                       .insertAllProduct(_.product.toList());
    //                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //                       backgroundColor: AppColors.primary,
    //                       content: Text('Sync Data success')));
    //                 });
    //           },
    //           builder: (context, state) {
    //             return state.maybeWhen(orElse: () {
    //               return ElevatedButton(
    //                   onPressed: () {
    //                     context
    //                         .read<ProductBloc>()
    //                         .add(const ProductEvent.fetch());
    //                   },
    //                   child: const Text('Sync Data'));
    //             }, loading: () {
    //               return const Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             });
    //           },
    //         ),
    //         const Divider(),
    //         BlocConsumer<LogoutBloc, LogoutState>(
    //           listener: (context, state) {
    //             state.maybeMap(
    //                 orElse: () {},
    //                 success: (_) {
    //                   AuthLocalDataSource().removeAuthData();
    //                   Navigator.pushReplacement(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => LoginPage(),
    //                     ),
    //                   );
    //                 });
    //           },
    //           builder: (context, state) {
    //             return ElevatedButton(
    //               onPressed: () {
    //                 context.read<LogoutBloc>().add(const LogoutEvent.logout());
    //               },
    //               child: const Text('Logout'),
    //             );
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
