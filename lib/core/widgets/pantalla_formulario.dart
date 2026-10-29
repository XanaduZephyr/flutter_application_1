import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/core/widgets/fondo_app.dart';

/// Estructura común de las pantallas con formulario.
///
/// Se encarga de todo lo visual que comparten login, registro y recuperar
/// contraseña: AppBar transparente, fondo de imagen, tarjeta centrada y el
/// [Form]. La pantalla solo pasa el título, su `GlobalKey` y los campos.
class PantallaFormulario extends StatelessWidget {
  const PantallaFormulario({
    super.key,
    required this.titulo,
    required this.formKey,
    required this.children,
  });

  /// Texto del AppBar.
  final String titulo;

  /// `GlobalKey` del formulario, para poder llamar a `validate()`.
  final GlobalKey<FormState> formKey;

  /// Campos y botones que van dentro de la tarjeta.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // La imagen también se dibuja detrás del AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: FondoApp(
        oscurecer: true,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                // En pantallas anchas (web/tablet) no se estira de más
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 8,
                  // Un poco transparente para que se vea el fondo
                  color: AppColors.surface.withValues(alpha: 0.94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    ),
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
