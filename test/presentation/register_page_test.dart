import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/pages/login_page.dart';
import 'package:flutter_application_1/presentation/pages/register_page.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';

void main() {
  testWidgets('El registro valida campos vacíos y contraseñas distintas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConPantalla(const RegisterPage()));

    // Contraseñas diferentes
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '654321');

    final boton = find.text('Crear cuenta');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pump();

    expect(find.text('Ingresa tu nombre'), findsOneWidget);
    expect(find.text('Ingresa tu correo'), findsOneWidget);
    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
  });

  testWidgets('El registro avisa si no se aceptan los términos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConPantalla(const RegisterPage()));

    final boton = find.text('Crear cuenta');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pump();

    expect(
      find.text('Debes aceptar los términos y condiciones'),
      findsOneWidget,
    );
  });

  testWidgets('El registro crea la cuenta y vuelve al login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appConRutas(rutaInicial: AppRoutes.register));

    await tester.enterText(find.byType(TextFormField).at(0), 'Ana López');
    await tester.enterText(find.byType(TextFormField).at(1), 'ana@mail.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    final boton = find.text('Crear cuenta');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pumpAndSettle();

    expect(find.text('Cuenta creada correctamente'), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
