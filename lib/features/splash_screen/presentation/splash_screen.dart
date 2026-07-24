import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/features/dashboard/presentation/dashboard_screen.dart';
import 'package:conferance_application/features/login_screen/presentation/login_screen.dart';
import 'package:conferance_application/features/splash_screen/cubit/splash_cubit.dart';
import 'package:conferance_application/features/splash_screen/cubit/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
        } else if (state is SplashNavigateToDashboard) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardScreen(
                responseModel: state.responseModel,
                clientCode: state.clientCode,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorwhite,
        body:
        SafeArea(
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
