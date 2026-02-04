
import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/features/dashboard/cubit/dashboard_screen_cubit.dart';
import 'package:conferance_application/features/dashboard/cubit/dashboard_screen_state.dart';
import 'package:conferance_application/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class DashboardScreenScreen extends StatelessWidget {
  const DashboardScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        duration: Durations.medium4,
        reverseDuration: Durations.medium4,
        overlayColor: colorwhite,
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return  Center(
            child:  Lottie.asset(
              AssetsPath.loadingImage,
            ),
          );
        },
        child: BlocProvider(
          key: ValueKey("Dashboard_screen_provider"),
          create: (context) => DashboardScreenCubit(),
          child: const DashboardScreenView(key: ValueKey("Dashboard_view")),
        ));
  }
}

class DashboardScreenView extends StatefulWidget {
  const DashboardScreenView({Key? key}) : super(key: key);
  @override
  State<DashboardScreenView> createState() => _DashboardScreenViewState();
}

class _DashboardScreenViewState extends State<DashboardScreenView> {

  late DashboardScreenCubit objDashboardScreenCubit;
  bool _isInitialized = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(backInterceptor, context: context);
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!_isInitialized) {
      objDashboardScreenCubit=BlocProvider.of<DashboardScreenCubit>(context);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backInterceptor);
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
      appBar:appBarwithNoBack(context,null),
      body:BlocConsumer<DashboardScreenCubit, DashboardScreenState>(
          listener: (context, state) {
            if(state is DashboardScreenLoading)
            {
              if (!context.loaderOverlay.visible) {
                context.loaderOverlay.show();
              }
            }
            else
            {
              context.loaderOverlay.hide();
            }
          },
          builder: (context, state) {
            return gradientContainer(child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [

                ],
              ),
            ));
          }
      ),

    );
  }


}