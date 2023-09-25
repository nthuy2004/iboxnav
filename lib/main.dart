import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iboxnav/app_binding.dart';
import 'package:iboxnav/config/routes.dart';
import 'package:iboxnav/config/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iboxnav/presentation/components/loading.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.black.withOpacity(0.1),
        overlayWidget: LoadingWidget(
          withRectangle: true,
          text: "Vui lòng chờ...",
        ),
        child: ResponsiveSizer(
            builder: (context, orientation, deviceType) => GetMaterialApp(
                  title: "iBoxNav",
                  locale: const Locale('vi'),
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('vi'), // VN
                    Locale('en')
                  ],
                  themeMode: ThemeMode.light,
                  theme: Themes.lightTheme,
                  debugShowCheckedModeBanner: false,
                  initialRoute: Routes.initialRoute,
                  getPages: Routes.getAll(),
                  initialBinding: AppBinding(),
                )));
  }
}
