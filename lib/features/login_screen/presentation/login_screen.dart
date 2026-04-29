import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_cubit.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../../../utils/locator.dart';

const Color _darkBlue = Color(0xFF2B2E8C);
const Color _gold = Color(0xFFFFC107);

class LoginScreenScreen extends StatelessWidget {
  const LoginScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        duration: Durations.medium4,
        reverseDuration: Durations.medium4,
        overlayColor: colorwhite,
        overlayWidgetBuilder: (_) {
          return Center(child: Lottie.asset(AssetsPath.loadingImage));
        },
        child: BlocProvider(
          key: const ValueKey("login_screen_provider"),
          create: (context) => LoginScreenCubit(locator<DashboardRepository>()),
          child: const LoginScreenView(key: ValueKey("login_view")),
        ));
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);
  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  late LoginScreenCubit objLoginScreenCubit;
  bool _isInitialized = false;
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backInterceptor, context: context);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      objLoginScreenCubit = BlocProvider.of<LoginScreenCubit>(context);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backInterceptor);
    _idController.dispose();
    super.dispose();
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (info.ifRouteChanged(context)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorwhite,
      body: BlocConsumer<LoginScreenCubit, LoginScreenState>(
        listener: (context, state) {
          if (state is LoginScreenLoading) {
            if (!context.loaderOverlay.visible) context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  // Motilal Oswal logo
                  Image.asset(
                    AssetsPath.motilalLogo,
                    height: 80.h,
                  ),

                  SizedBox(height: 48.h),

                  // 21st Annual Global Investor Conference logo
                  Image.asset(
                    AssetsPath.investorLogo,
                    height: 200.h,
                  ),

                  SizedBox(height: 16.h),

                  // Date & Venue pill
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _darkBlue,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '1st Sept – 5th Sept, 2025',
                          style: TextStyle(
                            color: colorwhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Grand Hyatt, Mumbai',
                          style: TextStyle(
                            color: colorwhite,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // 5 Digit Id text field
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '5 Digit Id',
                      hintStyle:
                          TextStyle(color: colortextHint, fontSize: 14.sp),
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: colortextHint),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: const BorderSide(color: _darkBlue),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        objLoginScreenCubit.getDashboardData(clientCode: _idController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkBlue,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: colorwhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Access note
                  Text(
                    'Access permitted to registered\nusers only',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorblue,
                      fontSize: 13.sp,
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
