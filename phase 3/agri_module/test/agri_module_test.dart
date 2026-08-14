import 'package:flutter_test/flutter_test.dart';
import 'package:agri_module/agri_module.dart';

void main() {
  testWidgets('Agri module renders dashboard screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AdyutaAgriApp());
    expect(find.text('Adyuta Agriculture'), findsOneWidget);
  });
}
