import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/chart_data_model.dart';
import '../text/app_text.dart';

class SalesPerformanceChart extends StatelessWidget {
  final List<ChartData> data;
  final String branchName;
  final double height;

  const SalesPerformanceChart({
    super.key,
    required this.data,
    required this.branchName,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Sales Performance',
          style: AppTextStyles.h3,
        ),
        AppText(
          branchName,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: data.isEmpty
              ? Center(
                  child: AppText(
                    'No data available',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                )
              : CustomPaint(
                  size: Size.infinite,
                  painter: _LineChartPainter(data),
                  child: _buildLabels(),
                ),
        ),
      ],
    );
  }

  Widget _buildLabels() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Y-axis values (top to bottom)
        Row(
          children: [
            AppText(
              '200',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            AppText(
              '150',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            AppText(
              '100',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            AppText(
              '50',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const Spacer(),
          ],
        ),

        // X-axis date labels (left to right)
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data
                .map((point) => AppText(
                      'Jan ${point.label}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartData> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height - 20; // Reserve space for X-axis labels

    // Draw horizontal grid lines
    _drawGridLines(canvas, width, height);

    // Draw line chart
    _drawLineChart(canvas, width, height);

    // Draw data points
    _drawDataPoints(canvas, width, height);
  }

  void _drawGridLines(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    // Draw four evenly spaced horizontal lines (representing 50, 100, 150, 200)
    final lineSpacing = height / 4;

    for (int i = 0; i <= 4; i++) {
      final y = height - (i * lineSpacing);
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }
  }

  void _drawLineChart(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Find max value for scaling
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    // Calculate point positions
    final pointWidth = width / (data.length - 1);

    // Start at the first point
    const startX = 0.0;
    final startY = height - (data[0].value / maxValue * height);
    path.moveTo(startX, startY);

    // Connect the points with a simple line
    for (int i = 1; i < data.length; i++) {
      final x = i * pointWidth;
      final y = height - (data[i].value / maxValue * height);
      path.lineTo(x, y);
    }

    // Draw the line
    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(Canvas canvas, double width, double height) {
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Find max value for scaling
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    // Calculate point positions
    final pointWidth = width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * pointWidth;
      final y = height - (data[i].value / maxValue * height);

      // Draw outer white circle
      canvas.drawCircle(Offset(x, y), 4, fillPaint);

      // Draw border
      canvas.drawCircle(Offset(x, y), 4, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
