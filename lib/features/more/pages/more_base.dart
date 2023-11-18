import '../../../core/router/module_provider.dart';
import '../../../core/router/navigator.dart';
import 'more.dart';
import '../../profile/pages/profile.dart';
import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  bool get _canPop {
    final navState = AppNavigator.getKey(Module.more).currentState;
    if (navState != null && navState.canPop()) {
      navState.pop();
      return false; // We handled the popping manually
    }
    return true; // Allow default behavior
  }

  @override
  Widget build(BuildContext context) {
    return ModuleProvider(
      module: Module.more,
      child: PopScope(
        canPop: _canPop,
        child: Navigator(
          key: AppNavigator.getKey(Module.more),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const MorePage(),
                );
              case '/profile':
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const ProfilePage(),
                );
              default:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No more route defined for ${settings.name}'),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
