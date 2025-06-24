import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermanager/features/product/presentation/pages/product.form.page.dart';
import '../cubit/product.cubit.dart';
import '../cubit/product.state.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductManagerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductManagerError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        final productList = state is ProductManagerLoaded ? state.products : [];

        return Scaffold(
          appBar: AppBar(title: const Text('Products')),
          body: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.unit.isNotEmpty
                    ? 'Unit: ${product.unit} | Category: ${product.categoryId}'
                    : 'Category: ${product.categoryId}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductFormPage(product: product),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<ProductCubit>().deleteProduct(product.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductFormPage()),
              );
            },
          ),
        );
      },
    );
  }
}
