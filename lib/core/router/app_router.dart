import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../constants/route_constants.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.home,
    routes: [
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // TODO: Add more routes as features are implemented
      // Auth routes
      // Games routes
      // Courts routes
      // Profile routes
    ],
  );
}
