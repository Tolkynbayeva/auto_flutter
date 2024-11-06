import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Auto extends StatelessWidget {
  const Auto({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375.0, 812.0),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          useInheritedMediaQuery: true,
          title: 'Auto Flutter',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
