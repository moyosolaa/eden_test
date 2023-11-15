import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:eden_test/features/auth/models/auth_state_model.dart';
import 'package:eden_test/localization/app_localization.dart';
import 'package:eden_test/shared/components/custom_image_view.dart';
import 'package:eden_test/shared/components/order_widget.dart';
import 'package:eden_test/shared/utilities/app_routes.dart';
import 'package:eden_test/shared/utilities/custom_text_style.dart';
import 'package:eden_test/shared/constants/image_constant.dart';
import 'package:eden_test/shared/utilities/loader.dart';
import 'package:eden_test/shared/utilities/size_utils.dart';
import 'package:eden_test/shared/utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState provider = ref.watch(authProvider);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 8.v),
                Padding(
                  padding: EdgeInsets.all(23.adaptSize),
                  child: provider.user == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "lbl_profile".tr,
                                style: CustomTextStyles.titleSmallBold,
                              ),
                            ),
                            SizedBox(height: 16.v),
                            CustomImageView(
                              imagePath: provider.user!.user!.photoURL,
                              height: 100.adaptSize,
                              width: 100.adaptSize,
                              radius: BorderRadius.circular(
                                50.h,
                              ),
                            ),
                            SizedBox(height: 8.v),
                            Text(provider.user!.user!.displayName!, style: theme.textTheme.titleMedium),
                            SizedBox(height: 2.v),
                            Text(provider.user!.user!.email!, style: theme.textTheme.bodySmall),
                          ],
                        ),
                ),
                // SizedBox(height: 31.v),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(23.adaptSize),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "lbl_my_orders".tr,
                              style: CustomTextStyles.titleSmallBold,
                            ),
                          ),
                          SizedBox(height: 12.v),
                          _orderWidget(context),
                          SizedBox(height: 36.v),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "lbl_settings".tr,
                              style: CustomTextStyles.titleSmallBold,
                            ),
                          ),
                          SizedBox(height: 10.v),
                          const Divider(),
                          _profileSettings(
                            context,
                            editProfile: "lbl_edit_profile".tr,
                            arrowRight: ImageConstant.imgArrowRight,
                          ),
                          _profileSettings(
                            context,
                            editProfile: "lbl_history".tr,
                            arrowRight: ImageConstant.imgArrowRight,
                          ),
                          _profileSettings(
                            context,
                            editProfile: "lbl_delivery".tr,
                            arrowRight: ImageConstant.imgArrowRight,
                          ),
                          _profileSettings(
                            context,
                            editProfile: "lbl_log_out".tr,
                            arrowRight: ImageConstant.imgArrowLeft,
                            onTapSetting: () async {
                              await ref
                                  .read(authProvider.notifier)
                                  .googleSignout()
                                  .then((value) => value ? onTapLogout(context) : null);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.v),
                const Divider(indent: 100, endIndent: 100),
                Text("\"A new day, another job opportunity to be world-class\"", style: theme.textTheme.bodySmall),
                const Divider(indent: 100, endIndent: 100),
                SizedBox(height: 10.v),
              ],
            ),
          ),
          provider.loading ? const Loader() : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _orderWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 16.v);
        },
        itemCount: 1,
        itemBuilder: (context, index) {
          return OrderWidget(
            onTapFrame: () {
              onTapOrder(context);
            },
          );
        },
      ),
    );
  }

  Widget _profileSettings(
    BuildContext context, {
    required String editProfile,
    required String arrowRight,
    Function? onTapSetting,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTapSetting?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.adaptSize),
                  child: Text(
                    editProfile,
                    style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.secondaryContainer),
                  ),
                ),
                CustomImageView(imagePath: arrowRight, height: 24.adaptSize, width: 24.adaptSize),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  onTapOrder(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.orderView);
  }

  onTapLogout(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginView);
  }
}
