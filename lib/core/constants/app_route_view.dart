import 'package:adoptme/features/view/web/responsive.dart';
import 'package:go_router/go_router.dart';

import '/features/view/views.dart';

GoRouter appRoute = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Responsive(
        webView: LoginWebView(),
        mobileView: LoginView(),
      ),
    ),
    GoRoute(
      path: LoginView.name,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/${RegisterView.name}',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/${HomeView.name}',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/${ProfileView.name}',
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: '/${PhotoView.name}',
      builder: (context, state) => const PhotoView(),
    ),
    GoRoute(
      path: '/${BottomNavbar.name}',
      builder: (context, state) => const BottomNavbar(),
    ),

    // Web Routes
    GoRoute(
      path: '/${RegisterWebView.name}',
      builder: (context, state) => const RegisterWebView(),
    ),
    GoRoute(
      path: '/${NavigatorWebView.name}',
      builder: (context, state) => const NavigatorWebView(),
    ),
  ],
);
