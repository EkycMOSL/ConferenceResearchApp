import 'package:conferance_application/features/login_screen/cubit/login_screen_cubit.dart';
import 'package:conferance_application/features/login_screen/presentation/login_screen.dart';
import 'package:conferance_application/features/splash_screen/cubit/splash_cubit.dart';
import 'package:conferance_application/features/splash_screen/presentation/splash_screen.dart';
import 'package:conferance_application/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'config/constant/colorsutils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await ScreenUtil.ensureScreenSize();// Add this line.
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'First Method',
              home: child,
              theme: ThemeData(
                primaryColor: Colors.yellow,
                primarySwatch: Colors.indigo,
                useMaterial3: false,
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD1D1D1),
                    )),
                bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: Colors.white),
                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
                chipTheme: ChipThemeData(
                    selectedColor: Colors.white,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: colorblack)),
                unselectedWidgetColor: colorblue,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ), //<-- SEE HERE
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      // width: 3,
                      color: Colors.black,
                    ), //<-- SEE HERE
                  ),
                ),
                scaffoldBackgroundColor: Colors.white,
                bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.yellow,
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                final mq = MediaQuery.of(context);
                // Apply your MediaQuery tweaks here (safe because it's inside GetMaterialApp)
                final safeMediaQuery = mq.copyWith(
                  boldText: false,
                  textScaler: const TextScaler.linear(1.0),
                );

                return MediaQuery(
                  data:safeMediaQuery,
                  child: child!,
                );
              }
          );
        },
        child: MyHomePage()
      //  const HomePage(title: 'First Method'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => SplashCubit(),
        ),
      ],
      child: const SplashScreen(),
    );
  }
}
