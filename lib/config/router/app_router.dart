import 'package:auto_route/auto_route.dart';

import '../../ui/screens/workouts_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WorkoutsRoute.page, initial: true),
      ];
}
