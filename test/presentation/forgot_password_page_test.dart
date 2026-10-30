import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/pages/forgot_password_page.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';

void main() {
  testWidgets('Recuperar contraseña valida el correo vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.forgotPassword));

    final boton = find.text('Enviar enlace de recuperación');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pump();

    expect(find.text('Ingresa tu correo'), findsOneWidget);
  });

  testWidgets('Recuperar contraseña muestra el SnackBar al enviar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.forgotPassword));

    expect(find.byType(ForgotPasswordPage), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'ana@mail.com');

    final boton = find.text('Enviar enlace de recuperación');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pumpAndSettle();

    expect(
      find.text('Se envió un enlace de recuperación a ana@mail.com'),
      findsOneWidget,
    );
  });
}
