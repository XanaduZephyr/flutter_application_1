import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación.
///
/// Todos los colores viven aquí para no repetir valores hexadecimales en las
/// pantallas: si quieres cambiar el tema, cambias este archivo y listo.
abstract final class AppColors {
  /// Color principal (fondo del splash, AppBar y botones).
  static const Color primary = Color(0xFF1E3A8A);

  /// Variante oscura del principal (degradados).
  static const Color primaryDark = Color(0xFF0F1F4B);

  /// Color de acento (detalles, iconos activos).
  static const Color accent = Color(0xFF38BDF8);

  /// Fondo general de las pantallas.
  static const Color background = Color(0xFFF5F7FB);

  /// Superficie de tarjetas y formularios.
  static const Color surface = Colors.white;

  /// Texto principal.
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundario (subtítulos, correos, etc.).
  static const Color textSecondary = Color(0xFF6B7280);

  /// Rojo para acciones destructivas (cerrar sesión).
  static const Color danger = Color(0xFFDC2626);

  /// Verde para confirmaciones.
  static const Color success = Color(0xFF16A34A);
}
