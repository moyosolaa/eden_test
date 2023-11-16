import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:eden_test/features/auth/models/auth_state_model.dart';
import 'package:eden_test/localization/app_localization.dart';
import 'package:eden_test/shared/components/custom_elevated_button.dart';
import 'package:eden_test/shared/components/custom_image_view.dart';
import 'package:eden_test/shared/components/custom_text_form_field.dart';
import 'package:eden_test/shared/constants/image_constant.dart';
import 'package:eden_test/shared/utilities/app_routes.dart';
import 'package:eden_test/shared/utilities/custom_text_style.dart';
import 'package:eden_test/shared/utilities/loader.dart';
import 'package:eden_test/shared/utilities/size_utils.dart';
import 'package:eden_test/shared/utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginView extends ConsumerWidget {
  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mediaQueryData = MediaQuery.of(context);
    AuthState provider = ref.watch(authProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 54.v),
              child: Column(
                children: [
                  const Spacer(flex: 46),
                  CustomImageView(
                    imagePath: ImageConstant.imgLogo,
                    height: 35.v,
                    width: 40.h,
                  ),
                  SizedBox(height: 7.v),
                  Text(
                    "lbl_welcome_back".tr,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    "msg_login_in_to_continue".tr,
                    style: CustomTextStyles.bodyMediumOnPrimaryContainer,
                  ),
                  SizedBox(height: 14.v),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: "lbl_email".tr,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.v),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "lbl_password".tr,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  SizedBox(height: 20.v),
                  CustomElevatedButton(
                    text: "lbl_log_in".tr,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please sign in with Google instead.'),
                        ),
                      );
                    },
                    buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3064E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 1.v,
                        width: 24.h,
                        margin: EdgeInsets.only(top: 8.v, bottom: 6.v),
                        decoration: BoxDecoration(color: appTheme.gray50001),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "msg_or_continue_with".tr,
                          style: CustomTextStyles.bodySmallGray50001,
                        ),
                      ),
                      Container(
                        height: 1.v,
                        width: 24.h,
                        margin: EdgeInsets.only(left: 8.h, top: 8.v, bottom: 6.v),
                        decoration: BoxDecoration(color: appTheme.gray50001),
                      )
                    ],
                  ),
                  SizedBox(height: 16.v),
                  SignInButton(
                    Buttons.googleDark,
                    onPressed: () async {
                      await ref.read(authProvider.notifier).googleSignIn(ref).then((value) => value
                          ? onTapLogIn(context)
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error logging in, please try again.'),
                              ),
                            ));
                    },
                  ),
                  SizedBox(height: 8.v),
                  SignInButton(
                    Buttons.gitHub,
                    onPressed: () async {
                      await ref.read(authProvider.notifier).githubSignIn(context, ref).then((value) => value
                          ? onTapLogIn(context)
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error logging in, please try again.'),
                              ),
                            ));
                    },
                  ),
                  const Spacer(flex: 53),
                ],
              ),
            ),
          ),
          provider.loading ? const Loader() : const SizedBox.shrink()
        ],
      ),
    );
  }

  /// Navigates to the profileScreen when the action is triggered.
  onTapLogIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.profileView);
  }
}
