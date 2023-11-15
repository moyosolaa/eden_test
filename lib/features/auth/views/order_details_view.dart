import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:eden_test/features/auth/models/auth_state_model.dart';
import 'package:eden_test/localization/app_localization.dart';
import 'package:eden_test/shared/components/custom_elevated_button.dart';
import 'package:eden_test/shared/components/custom_image_view.dart';
import 'package:eden_test/shared/utilities/app_routes.dart';
import 'package:eden_test/shared/utilities/custom_text_style.dart';
import 'package:eden_test/shared/constants/image_constant.dart';
import 'package:eden_test/shared/utilities/size_utils.dart';
import 'package:eden_test/shared/utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState provider = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgArrowLeftBlueA700,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.centerLeft,
                    onTap: () {
                      onTapBack(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Order Details',
                    style: CustomTextStyles.titleSmallBold,
                  )
                ],
              ),
              SizedBox(height: 36.v),
              Text('STATUS: ${provider.orderStatus.name}'),
              SizedBox(height: 36.v),
              CustomImageView(
                imagePath: ImageConstant.imgRectangle6280x380,
                height: 280.v,
                width: 380.h,
                radius: BorderRadius.circular(4.h),
              ),
              SizedBox(height: 16.v),
              _buildOrderDetailsCard(context),
              SizedBox(height: 16.v),
              CustomElevatedButton(
                text: "lbl_track_order".tr,
                onPressed: () {
                  onTapTrackOrder(context);
                },
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3064E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 5.v)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 15.v),
      decoration: BoxDecoration(
        color: appTheme.gray50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOrderDetails(context, item: "lbl_order_name".tr, value: "lbl_non_stick_pot".tr),
          SizedBox(height: 7.v),
          _buildOrderDetails(context, item: "lbl_order_id".tr, value: "lbl_49694nf6ckm44".tr),
          SizedBox(height: 7.v),
          _buildOrderDetails(context, item: "lbl_order_time".tr, value: "lbl_13_11_23_8_49pm".tr),
          SizedBox(height: 6.v),
          _buildOrderDetails(context, item: "lbl_quantity".tr, value: "lbl_2".tr),
          SizedBox(height: 6.v),
          _buildOrderDetails(context, item: "lbl_price".tr, value: "lbl_29_99".tr)
        ],
      ),
    );
  }

  Widget _buildOrderDetails(
    BuildContext context, {
    required String item,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.secondaryContainer)),
        Text(value, style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.secondaryContainer))
      ],
    );
  }

  onTapBack(BuildContext context) {
    Navigator.pop(context);
  }

  onTapTrackOrder(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.trackOrderView);
  }
}
