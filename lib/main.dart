import 'package:admin_panel/common/cubit/system_cubit.dart';
import 'package:admin_panel/common/cubit/theme_cubit.dart';
import 'package:admin_panel/core/configs/theme.dart';
import 'package:admin_panel/firebase_options.dart';
import 'package:admin_panel/presentation/auth/pages/signup.dart';
import 'package:admin_panel/presentation/auth/pages/singin.dart';
import 'package:admin_panel/presentation/chat/chat_page.dart';
import 'package:admin_panel/presentation/home/pages/home_page.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:admin_panel/presentation/settings/config_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SystemCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: themeMode,
            locale: context.watch<SystemCubit>().currentLocale,
            supportedLocales: const [Locale('en'), Locale('he')],
            builder:
                (context, child) => ResponsiveBreakpoints.builder(
                      child: child!,
                      breakpoints: [
                        const Breakpoint(start: 0, end: 450, name: MOBILE),
                        const Breakpoint(start: 451, end: 800, name: TABLET),
                        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                        const Breakpoint(
                          start: 1921,
                          end: double.infinity,
                          name: '4K',
                        ),
                      ],
                    ),
            initialRoute: '/signin',
            routes: {
              '/signin': (context) => SigninPage(),
              '/homePage': (context) => HomePage(),
              // '/customersPage': (context) => CustomersPage(),
              '/chatPage': (context) => ChatPage(),
              '/config': (context) => const ConfigPage(),
            },
          );
        },
      ),
    );
  }
}
