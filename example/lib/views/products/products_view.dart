import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../theme/app_theme.dart';
import 'cubit/products_cubit.dart';
import 'cubit/products_state.dart';

/// Products View - Minimalist design
class ProductsView extends MasterViewCubit<ProductsCubit, ProductsState> {
  ProductsView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Products'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                BlocBuilder<ProductsCubit, ProductsState>(
                  bloc: viewModel,
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        state.isSearchActive
                            ? LucideIcons.x
                            : LucideIcons.search,
                        size: 18,
                      ),
                      onPressed: () => viewModel.toggleSearch(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  onPressed: () => viewModel.loadProducts(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      ProductsCubit viewModel, BuildContext context) async {
    await viewModel.loadProducts();
  }

  @override
  Widget viewContent(
      BuildContext context, ProductsCubit viewModel, ProductsState state) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      bloc: viewModel,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Error',
                    style: const TextStyle(color: AppTheme.error)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => viewModel.loadProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (state.isSearchActive)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon:
                        const Icon(LucideIcons.search, size: 16),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () => viewModel.clearSearch(),
                          )
                        : null,
                  ),
                  style: AppTheme.mono,
                  onChanged: (value) => viewModel.searchProducts(value),
                ),
              ),
            Expanded(child: _buildList(context, viewModel, state)),
          ],
        );
      },
    );
  }

  Widget _buildList(
      BuildContext context, ProductsCubit viewModel, ProductsState state) {
    final products =
        state.isSearchActive ? state.filteredProducts : state.products;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.packageX,
                size: 32, color: AppTheme.textMuted),
            const SizedBox(height: 12),
            Text(
              state.isSearchActive ? 'No results' : 'No products',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.bg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  product.name[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      style:
                                          Theme.of(context).textTheme.titleSmall),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: AppTheme.mono.copyWith(
                                        fontSize: 10, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight,
                                size: 14, color: AppTheme.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < products.length - 1) const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
