class RouteNames {
  RouteNames._();

  // Namen der Routen (für context.goNamed)
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String session = 'session';

  // Pfade der Routen (für die Router Config)
  static const String loginPath = '/login';
  static const String dashboardPath = '/';
  static const String sessionPath = 'session/:sessionId'; // Sub-Route
}
