import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turn_slate/main.dart';

void main() {
  for (final platform in [
    TargetPlatform.iOS,
    TargetPlatform.android,
    TargetPlatform.windows,
  ]) {
    for (final width in [390.0, 800.0, 1280.0]) {
      testWidgets('scaffold smoke $platform ${width.toInt()}', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        try {
          await tester.binding.setSurfaceSize(Size(width, 800));
          await tester.pumpWidget(const TurnSlateApp());
          expect(find.text('TURN SLATE'), findsOneWidget);
          expect(find.textContaining('being prepared'), findsOneWidget);
          expect(find.byType(SafeArea), findsOneWidget);
          expect(tester.takeException(), isNull);
        } finally {
          debugDefaultTargetPlatformOverride = null;
          await tester.binding.setSurfaceSize(null);
        }
      });
    }
  }
}
