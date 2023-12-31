import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'core/providers/providers.dart';
import 'core/size_util.dart';
import 'core/themes/themes.dart';
import 'widgetbook.directories.g.dart';

void main() {
  runApp(const ProviderScope(child: WidgetbookApp()));
}

@widgetbook.App()
class WidgetbookApp extends ConsumerWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Widgetbook.material(
      directories: directories,
      initialRoute: '/?path=core/widgets/devfestbottomnav/devfest-bottom-nav',
      addons: [
        DeviceFrameAddon(
          devices: [
            DeviceInfo.genericPhone(
              platform: TargetPlatform.iOS,
              id: 'custom-device',
              name: 'Designer Frame',
              screenSize: const Size(430, 960),
            ),
            ...Devices.ios.all.where(
                (element) => element.identifier.type == DeviceType.phone),
            ...Devices.android.all.where(
                (element) => element.identifier.type == DeviceType.phone),
          ],
          initialDevice: Devices.ios.iPhone13ProMax,
        ),
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
                textTheme: const TextTheme(
                    bodyMedium: TextStyle(color: DevfestColors.grey0)),
                extensions: const <ThemeExtension<dynamic>>[
                  /// Use the below format for raw theme data
                  /// DevFestTheme(textTheme: DevfestTextTheme()),
                  // DevFestTheme.light(),
                ],
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                textTheme: const TextTheme(
                    bodyMedium: TextStyle(color: DevfestColors.background)),
                extensions: const <ThemeExtension<dynamic>>[
                  /// Use the below format for raw theme data
                  /// DevFestTheme(textTheme: DevfestTextTheme()),
                  // DevFestTheme.dark(),
                ],
              ),
            ),
          ],
          themeBuilder: (context, theme, child) {
            final isDark = theme.brightness == Brightness.dark ? true : false;
            ref
                .read(themeManagerProvider.notifier)
                .updateThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
            return ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              useInheritedMediaQuery: true,
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme.copyWith(extensions: [
                    isDark ? DevFestTheme.dark() : DevFestTheme.light()
                  ]),
                  home: Material(child: child),
                );
              },
              child: child,
            );
          },
        )
      ],
    );
  }
}
