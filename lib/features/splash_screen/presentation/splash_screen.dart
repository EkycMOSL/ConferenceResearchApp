import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/features/login_screen/presentation/login_screen.dart';
import 'package:conferance_application/features/splash_screen/cubit/splash_cubit.dart';
import 'package:conferance_application/features/splash_screen/cubit/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

const Color _darkBlue = Color(0xFF2B2E8C);

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplashTimer(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = '${info.version}(${info.buildNumber})';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToLogin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreenScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorwhite,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Investor logo (21st circle)
              Image.asset(
                AssetsPath.investorLogo,
                width: 220.w,
                height: 220.h,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 16.h),

              // Date & Venue pill
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
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
              ),

              const Spacer(),

              // App version
              Text(
                'App Version : $_version',
                style: TextStyle(
                  color: colorblack,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
