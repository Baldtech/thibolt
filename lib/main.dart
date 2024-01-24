import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/common_libs.dart';
import 'config/themes/app_theme.dart';
import 'domain/repository/workout_repository.dart';
import 'locator.dart';
import 'ui/cubits/workouts/workouts_cubit.dart';
import 'config/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WorkoutsCubit(
            locator<WorkoutRepository>(),
          )..getAllWorkouts(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
        theme: AppTheme.light,
      ),
    );
  }
}
