import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:eden_test/localization/app_localization.dart';
import 'package:eden_test/shared/components/custom_image_view.dart';
import 'package:eden_test/shared/constants/image_constant.dart';
import 'package:eden_test/shared/utilities/custom_text_style.dart';
import 'package:eden_test/shared/utilities/size_utils.dart';
import 'package:eden_test/shared/utilities/theme_helper.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    Key? key,
    this.onTapFrame,
    required this.status,
  }) : super(key: key);

  final VoidCallback? onTapFrame;
  final OrderStatusEnum status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.gray50,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTapFrame!.call();
          },
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRectangle6,
                  height: 60.adaptSize,
                  width: 60.adaptSize,
                  radius: BorderRadius.circular(
                    2.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "lbl_non_stick_pot".tr,
                        style: theme.textTheme.labelLarge,
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        "lbl_49694nf6ckm44".tr,
                        style: theme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 5.v),
                      Text(
                        "Status: ${status.name}",
                        style: CustomTextStyles.bodySmallGray500,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.v),
                  child: Text(
                    "lbl_29_99".tr,
                    style: CustomTextStyles.titleSmallBold_1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
