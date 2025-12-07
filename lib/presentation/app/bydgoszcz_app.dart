import 'package:bydgoszcz/core/constants/app_constants.dart';
import 'package:bydgoszcz/core/theme/app_theme.dart';
import 'package:bydgoszcz/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class BydgoszczApp extends StatefulWidget {
  const BydgoszczApp({super.key});

  @override
  State<BydgoszczApp> createState() => _BydgoszczAppState();
}

class _BydgoszczAppState extends State<BydgoszczApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appRouter.appCubit,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        routerConfig: _appRouter.router,
      ),
    );
  }

  @override
  void dispose() {
    _appRouter.appCubit.close();
    super.dispose();
  }
}
