import 'package:flutter/material.dart';

/// Fondo con imagen reutilizable por el splash, el login y el registro.
///
/// Centraliza la ruta del asset: si cambias la imagen, la cambias solo aquí.
class FondoApp extends StatelessWidget {
  const FondoApp({
    super.key,
    required this.child,
    this.oscurecer = false,
    this.rutaImagen = rutaImagenPorDefecto,
  });

  /// Ruta de la imagen declarada en `pubspec.yaml` (sección flutter > assets).
  ///
  /// Importante: sin espacios ni paréntesis en el nombre, porque en web
  /// (GitHub Pages) esos caracteres rompen la URL del asset.
  static const String rutaImagenPorDefecto = 'assets/wallpaper.png';

  /// Contenido que se dibuja encima de la imagen.
  final Widget child;

  /// Si es `true` agrega un degradado oscuro para mejorar el contraste.
  final bool oscurecer;

  /// Imagen de fondo a usar.
  final String rutaImagen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Capa de imagen de fondo
        DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(rutaImagen),
              fit: BoxFit.cover,
              // Suaviza el escalado en pantallas grandes (web/escritorio)
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        // 2. Degradado opcional para dar contraste al contenido
        if (oscurecer)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.20),
                ],
              ),
            ),
          ),
        // 3. Contenido encima del fondo
        child,
      ],
    );
  }
}
