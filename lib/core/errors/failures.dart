/// Errores personalizados de la aplicación.
///
/// La capa de datos los lanza y la capa de presentación los transforma en un
/// mensaje para el usuario (SnackBar / texto de error).
class Failure implements Exception {
  const Failure(this.mensaje);

  /// Mensaje listo para mostrarse en la UI.
  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Error de autenticación (credenciales, registro, correo...).
class AuthFailure extends Failure {
  const AuthFailure(super.mensaje);
}

/// Error de comunicación con el servidor.
class NetworkFailure extends Failure {
  const NetworkFailure([super.mensaje = 'No hay conexión con el servidor']);
}
