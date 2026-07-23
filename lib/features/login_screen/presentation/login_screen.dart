import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/features/dashboard/presentation/dashboard_screen.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_cubit.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../../../utils/locator.dart';

const Color _darkBlue = Color(0xFF1A1F8F);

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
            if (state is AnalystScheduleSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(
                    responseModel: state.responseModel,
                    clientCode: _idController.text.trim(),
                  ),
                ),
              );
            } else if (state is LoginScreenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // ── Top logo (full width, stretch to remove inner padding) ──
                SizedBox(
                  width: double.infinity,
                  height: 140.h,
                  child: Image.asset(
                    AssetsPath.top_icon,
                    fit: BoxFit.fill,
                  ),
                ),


                // ── Middle 22nd circle logo ──
                Image.asset(
                  AssetsPath.middle_icon,
                  height: 140.h,
                  fit: BoxFit.contain,
                ),


                // ── "Annual Global Investor Conference" text ──
                Text(
                  'Annual Global\nInvestor Conference',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tinos(
                    color: _darkBlue,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),


                // ── India Ahead logo ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  child: Image.asset(
                    AssetsPath.india_icon,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),

                const Spacer(),

                // ── 5 Digit ID text field ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colortextHint, fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: '5 Digit ID',
                      hintStyle:
                          TextStyle(color: colortextHint, fontSize: 16.sp),
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide:
                            BorderSide(color: colortextHint, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide:
                            const BorderSide(color: _darkBlue, width: 1.5),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // ── Login button ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_idController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your 5 digit ID')),
                          );
                          return;
                        }
                        objLoginScreenCubit.getDashboardData(
                          clientCode: _idController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkBlue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: colorwhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // ── Access note ──
                Text(
                  'Access permitted to registered\nusers only',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _darkBlue,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
