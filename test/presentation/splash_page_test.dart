import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/pages/login_page.dart';
import 'package:flutter_application_1/presentation/pages/splash_page.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';

void main() {
  testWidgets('El splash dura 3 segundos y redirige al login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.splash));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('UserMaster'), findsOneWidget);
    expect(find.text('Cargando...'), findsOneWidget);

    // A los 2 segundos sigue en el splash
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(SplashPage), findsOneWidget);

    // Al tercer segundo navega al login
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('El splash se adapta a una pantalla de móvil', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.splash));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Móvil (<600): escala 1.0 => el texto mide 16 px
    final texto = tester.widget<Text>(find.text('Cargando...'));
    expect(texto.style?.fontSize, moreOrLessEquals(16.0));

    // Deja terminar el temporizador
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('El splash se adapta a una pantalla de escritorio', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.splash));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Escritorio (>=1024): escala 1.6 => el texto mide 25.6 px
    final texto = tester.widget<Text>(find.text('Cargando...'));
    expect(texto.style?.fontSize, moreOrLessEquals(25.6));

    // Deja terminar el temporizador
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
