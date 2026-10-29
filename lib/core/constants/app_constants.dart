/// Constantes globales de la aplicación "UserMaster".
///
/// Aquí viven los valores que se repiten en varias capas, para no tener
/// "números y textos mágicos" regados por el código.
abstract final class AppConstants {
  /// Nombre visible de la aplicación.
  static const String nombreApp = 'UserMaster';

  /// Versión que se muestra en el splash.
  static const String version = '1.0.0';

  /// El splash debe durar exactamente 3 segundos.
  static const Duration duracionSplash = Duration(seconds: 3);

  /// Retardo que simula la respuesta del backend (login, registro, etc.).
  static const Duration retardoSimulado = Duration(seconds: 2);

  /// Longitud mínima de la contraseña.
  static const int longitudMinimaPassword = 6;

  /// Longitud mínima del nombre completo.
  static const int longitudMinimaNombre = 3;

  /// Datos por defecto del usuario cuando aún no hay sesión real.
  static const String usuarioDemo = 'Usuario Demo';
  static const String correoDemo = 'usuario@demo.com';
}
