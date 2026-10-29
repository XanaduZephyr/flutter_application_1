/// Excepción de la capa de dominio para los errores de autenticación.
///
/// La lanza la fuente de datos simulada y la traduce
/// `AuthRepositoryImpl` a un `AuthFailure` de la capa `core/errors`.
class AuthException implements Exception {
  const AuthException(this.mensaje);

  /// Texto que explica el problema.
  final String mensaje;

  @override
  String toString() => mensaje;
}
