import 'package:bloc/bloc.dart';
import 'package:fic11_starter_pos/data/datasource/models/response/product_response_model.dart';
import 'package:fic11_starter_pos/data/datasource/product_remote_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/product_local_datasource.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(this.productRemoteDatasource) : super(_Initial()) {
    on<_Fetch>((event, emit) async {
      emit(ProductState.loading());
      final response = await productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(
          ProductState.error(l),
        ),
        (r) {
          products = r.data;
          emit(ProductState.success(r.data));
        },
      );
    });

    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      final localPproducts =
          await ProductLocalDatasource.instance.getAllProduct();
      products = localPproducts;

      emit(ProductState.success(products));
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());
      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();
      emit(ProductState.success(newProducts));
    });
  }
}
