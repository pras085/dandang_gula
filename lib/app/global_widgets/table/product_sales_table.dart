import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/product_sales_model.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class ProductSalesTable extends StatelessWidget {
  final String title;
  final List<ProductSales> products;
  final VoidCallback onViewAll;

  const ProductSalesTable({
    super.key,
    required this.title,
    required this.products,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      action: TextButton(
        onPressed: onViewAll,
        child: const Row(
          children: [
            AppText(
              'Lainya',
              style: TextStyle(color: AppColors.primary),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  'Produk',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AppText(
                  'Total Pesanan',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: AppText(
                  'Total Penjualan',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const Divider(),
          ...products.map((product) => _buildProductRow(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductRow(ProductSales product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    product.name,
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppText(
              product.orderCount.toString(),
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: AppText(
              'Rp${product.totalSales.toStringAsFixed(0)}',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
