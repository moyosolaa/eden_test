import 'package:dotted_border/dotted_border.dart';
import 'package:eden_test/features/orders/controllers/order_controller.dart';
import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:eden_test/localization/app_localization.dart';
import 'package:eden_test/shared/components/custom_image_view.dart';
import 'package:eden_test/shared/constants/image_constant.dart';
import 'package:eden_test/shared/utilities/custom_text_style.dart';
import 'package:eden_test/shared/utilities/size_utils.dart';
import 'package:eden_test/shared/utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackOrderView extends ConsumerWidget {
  const TrackOrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OrderStatusEnum orderStatus = ref.watch(orderProvider).orderStatus;
    DateTime? dateTime = ref.watch(orderProvider).timestamp;
    int status = ref.watch(orderProvider.notifier).handleOrderStatus(orderStatus);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.adaptSize),
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
                      onTapArrowLeft(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'lbl_track_item'.tr,
                    style: CustomTextStyles.titleSmallBold,
                  )
                ],
              ),
              SizedBox(height: 18.v),
              _buildOrderDetailCard(context),
              SizedBox(height: 24.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'lbl_order_status'.tr,
                  style: CustomTextStyles.titleSmallBold,
                ),
              ),
              SizedBox(height: 24.v),
              Expanded(
                child: ListView(
                  children: [
                    status >= 0
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "lbl_order_placed".tr,
                            timestamp: dateTime,
                            message: 'Your order has been successfully placed',
                          )
                        : _buildPendingOrderStatus(context, "lbl_order_placed".tr),
                    status >= 1
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "lbl_order_accepted".tr,
                            timestamp: dateTime!,
                            message: 'Your order has been accepted and is being prepared by your vendor',
                          )
                        : _buildPendingOrderStatus(context, "lbl_order_accepted".tr),
                    status >= 2
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "msg_order_pickup_in".tr,
                            timestamp: dateTime!,
                            message: 'The rider is on his way to pick up your order from the vendor',
                          )
                        : _buildPendingOrderStatus(context, "msg_order_pickup_in".tr),
                    status >= 3
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "msg_order_on_the_way".tr,
                            timestamp: dateTime!,
                            message: 'The rider has picked up your order and is on your way',
                          )
                        : _buildPendingOrderStatus(context, "msg_order_on_the_way".tr),
                    status >= 4
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "lbl_order_arrived".tr,
                            timestamp: dateTime!,
                            message: "Don't keep the rider waiting, he's outside",
                          )
                        : _buildPendingOrderStatus(context, "lbl_order_arrived".tr),
                    status >= 5
                        ? _buildConfirmedOrderStatus(
                            context,
                            status: "lbl_order_delivered".tr,
                            timestamp: dateTime!,
                            message: 'Enjoy!',
                          )
                        : _buildPendingOrderStatus(context, "lbl_order_delivered".tr),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailCard(BuildContext context) {
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

  Widget _buildConfirmedOrderStatus(
    BuildContext context, {
    required String status,
    required String message,
    required DateTime? timestamp,
  }) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 23.h, vertical: 14.v),
          decoration: BoxDecoration(
            border: Border.all(color: appTheme.blueA700, width: 2.h),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: appTheme.blueA700,
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(status.tr, style: CustomTextStyles.titleSmallBlueA700),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.v),
              Text(
                message,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.v),
              Text(timestamp == null ? '2023-11-15 17:00:00' : timestamp.toString(),
                  style: CustomTextStyles.bodySmallGray600)
            ],
          ),
        ),
        SizedBox(height: 1.v),
        status == 'Order Delivered'
            ? const SizedBox.shrink()
            : CustomImageView(
                imagePath: ImageConstant.imgVector4,
                height: 47.v,
                width: 1.h,
                color: appTheme.blueA700,
              ),
      ],
    );
  }

  Widget _buildPendingOrderStatus(BuildContext context, String status) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Opacity(
            opacity: 0.5,
            child: DottedBorder(
              color: theme.colorScheme.primary,
              padding: EdgeInsets.all(16.adaptSize),
              strokeWidth: 1.h,
              radius: const Radius.circular(4),
              borderType: BorderType.RRect,
              dashPattern: const [2, 2],
              child: Center(
                child: Text(
                  status,
                  style: CustomTextStyles.titleSmallSemiBold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.v),
        status == 'Order Delivered'
            ? const SizedBox.shrink()
            : CustomImageView(imagePath: ImageConstant.imgVector4, height: 47.v, width: 1.h),
      ],
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

  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
