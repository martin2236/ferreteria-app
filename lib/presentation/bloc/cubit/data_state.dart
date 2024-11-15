// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_cubit.dart';

class DataCubitState extends Equatable {
  final String? nombreCompra;
  final List<Producto> pedido;
  final List<Categoria>? categorias;
  final List<Medida>? medidas;
  final List<Compra>? compras;
  final List<Producto>? productos;

  const DataCubitState({
    this.pedido = const [],
    this.nombreCompra,
    this.categorias,
    this.medidas,
    this.compras,
    this.productos,
  });

  DataCubitState copyWith({
    List<Producto>? pedido,
    List<Producto>? productos,
    String? nombreCompra,
    List<Categoria>? categorias,
    List<Medida>? medidas,
    List<Compra>? compras,
  }) {
    return DataCubitState(
      pedido: pedido ?? this.pedido,
      nombreCompra: nombreCompra ?? this.nombreCompra,
      categorias: categorias ?? this.categorias,
      medidas: medidas ?? this.medidas,
      compras: compras ?? this.compras,
      productos: productos ?? this.productos
    );
  }
  
  @override
  List<Object?> get props => [nombreCompra,categorias,medidas,compras,pedido,productos];
 }

