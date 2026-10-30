import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/pages/dashboard_page.dart';
import 'package:flutter_application_1/presentation/pages/login_page.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';

void main() {
  testWidgets('El login valida los campos vacíos', (WidgetTester tester) async {
    await tester.pumpWidget(appConPantalla(const LoginPage()));

    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Ingresa tu correo'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('El login carga 2 segundos y redirige al dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      appConRutas(
        rutaInicial: AppRoutes.login,
        retardo: const Duration(seconds: 2),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'ana@mail.com');
    await tester.enterText(find.byType(TextFormField).last, '123456');

    await tester.tap(find.text('Ingresar'));
    await tester.pump(); // inicia la carga

    // Mientras carga se ve el indicador circular
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Al primer segundo todavía no navega
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(DashboardPage), findsNothing);

    // A los 2 segundos entra al dashboard
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsOneWidget);
  });

  testWidgets('El login entra al dashboard con credenciales válidas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.login));

    await tester.enterText(find.byType(TextFormField).first, 'ana@mail.com');
    await tester.enterText(find.byType(TextFormField).last, '123456');

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    // Con datos válidos entra directo al dashboard
    expect(find.byType(DashboardPage), findsOneWidget);
  });
}
