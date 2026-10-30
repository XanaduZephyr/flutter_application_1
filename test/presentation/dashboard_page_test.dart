import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/pages/dashboard_page.dart';
import 'package:flutter_application_1/presentation/pages/login_page.dart';
import 'package:flutter_application_1/presentation/pages/profile_page.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';
import 'package:flutter_application_1/presentation/widgets/tarjeta_reciente.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';

void main() {
  testWidgets('El dashboard muestra el saludo y al menos 5 tarjetas', (
    WidgetTester tester,
  ) async {
    // Pantalla alta para que el ListView construya todas las tarjetas
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.dashboard));

    expect(find.text('Hola, Usuario'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Al menos 5 tarjetas de ejemplo
    expect(elementosRecientes.length, greaterThanOrEqualTo(5));
    expect(
      find.byType(TarjetaReciente),
      findsNWidgets(elementosRecientes.length),
    );
  });

  testWidgets('La pestaña Perfil muestra avatar, nombre y correo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.dashboard));

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byIcon(Icons.person), findsWidgets);
    expect(find.text('Usuario Demo'), findsOneWidget);
    expect(find.text('usuario@demo.com'), findsOneWidget);
  });

  testWidgets('Cerrar sesión destruye el historial y vuelve al login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.dashboard));

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    final cerrar = find.text('Cerrar sesión');
    await tester.ensureVisible(cerrar);
    await tester.pumpAndSettle();
    await tester.tap(cerrar);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    // No queda historial: no se puede volver atrás
    final navigator = Navigator.of(tester.element(find.byType(LoginPage)));
    expect(navigator.canPop(), isFalse);
  });
}
