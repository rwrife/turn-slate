import 'package:flutter/widgets.dart';

void main() => runApp(const TurnSlateApp());

class TurnSlateApp extends StatelessWidget {
  const TurnSlateApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFF14232D),
    pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
        PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
        ),
    home: const _WelcomeBoard(),
  );
}

class _WelcomeBoard extends StatelessWidget {
  const _WelcomeBoard();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return ColoredBox(
      color: const Color(0xFF14232D),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: wide ? 680 : 400),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF203746),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF728B96)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TURN SLATE',
                        style: TextStyle(
                          color: Color(0xFFF9D988),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your encounter board is being prepared.',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Offline initiative, conditions and saves arrive in upcoming updates.',
                        style: TextStyle(
                          color: Color(0xFFD8E5E8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
