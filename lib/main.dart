import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'logic/theme/theme_bloc.dart';
import 'logic/theme/theme_state.dart';
import 'logic/canvas/canvas_bloc.dart';
import 'logic/projects/projects_bloc.dart';
import 'logic/projects/projects_event.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_event.dart';
import 'core/app_router.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed. Error: $e');
  }

  runApp(const DesignGridApp());
}

class DesignGridApp extends StatefulWidget {
  const DesignGridApp({super.key});

  @override
  State<DesignGridApp> createState() => _DesignGridAppState();
}

class _DesignGridAppState extends State<DesignGridApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc()..add(LoadSettingsEvent());
    _router = AppRouter.router(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => CanvasBloc()),
        BlocProvider(create: (context) => ProjectsBloc()..add(LoadProjectsEvent())),
        BlocProvider.value(value: _authBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'DesignGrid.AI',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
