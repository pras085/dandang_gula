import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/category_sales_model.dart';
import '../text/app_text.dart';

class CategoryChart extends StatelessWidget {
  final List<CategorySales> data;

  const CategoryChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a simplified implementation
    // You would use a chart library for a real implementation
    
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }
    
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: CustomPaint(
                painter: _PieChartPainter(data),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: data.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _hexToColor(item.color),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                AppText(
                  item.name,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class _PieChartPainter extends CustomPainter {
  final List<CategorySales> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    double startAngle = 0;
    
    for (final item in data) {
      final sweepAngle = item.percentage / 100 * 2 * 3.14159; // Convert to radians
      
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _hexToColor(item.color);
      
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      startAngle += sweepAngle;
    }
    
    // Draw center circle for donut chart
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

