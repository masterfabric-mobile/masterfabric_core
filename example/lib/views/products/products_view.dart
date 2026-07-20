import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../theme/theme_helper.dart';
import '../../src/resources/resources.g.dart' as example_resources;
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
          extendBodyBehindAppBar: false,
          extendBody: false,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.products.title),
              actions: [
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: viewModel.state.isSearchActive
                        ? LucideIcons.x
                        : LucideIcons.search,
                    size: 18,
                  ),
                  onPressed: () => viewModel.toggleSearch(),
                ),
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.refreshCw,
                    size: 18,
                  ),
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
    // Check if products view is visible
    if (!context.isViewVisible('products')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              example_resources.resources.products.products_view_hidden,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.themeCubit.toggleViewVisibility('products', true),
              child: Text(example_resources.resources.products.show_products_view),
            ),
          ],
        ),
      );
    }

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
            Text(state.errorMessage ?? example_resources.resources.common.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => viewModel.loadProducts(),
              child: Text(example_resources.resources.common.retry),
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
                    hintText: example_resources.resources.search.hint,
                    prefixIcon: ConditionalIcon(
                      context: context,
                      icon: LucideIcons.search,
                      size: 16,
                    ),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: ConditionalIcon(
                              context: context,
                              icon: LucideIcons.x,
                              size: 16,
                            ),
                            onPressed: () => viewModel.clearSearch(),
                          )
                        : null,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                  onChanged: (value) => viewModel.searchProducts(value),
                ),
              ),
            Expanded(child: _buildList(context, viewModel, state)),
          ],
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
            ConditionalIcon(
              context: context,
              icon: LucideIcons.packageX,
              size: 32,
              color: context.textMutedColor,
            ),
            const SizedBox(height: 12),
            Text(
              state.isSearchActive ? example_resources.resources.products.no_results : example_resources.resources.products.no_products,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          decoration: context.cardDecoration,
          clipBehavior: Clip.antiAlias,
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
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  product.name[0].toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: context.accentColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      style:
                                          Theme.of(context).textTheme.titleSmall),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontFamily: 'monospace',
                                          color: context.textMutedColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            ConditionalIcon(
                              context: context,
                              icon: LucideIcons.chevronRight,
                              size: 18,
                              color: context.textMutedColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < products.length - 1)
                    Divider(height: 1, color: context.borderColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
