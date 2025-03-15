import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../controllers/branch_management_controller.dart';

class BranchManagementView extends GetView<BranchManagementController> {
  const BranchManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Management Cabang',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Obx(() => controller.isLoading.value ? const CircularProgressIndicator() : const AppText('Konten Management Cabang')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
