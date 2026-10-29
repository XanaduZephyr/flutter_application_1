import 'package:flutter_application_1/domain/entities/usuario.dart';

/// Contrato (interfaz) del repositorio de autenticación.
///
/// El dominio solo conoce esta interfaz; la implementación real vive en
/// `data/repositories/auth_repository_impl.dart`. Así se puede cambiar la
/// fuente de datos (API, base local, Firebase...) sin tocar la UI.
abstract interface class AuthRepository {
  /// Valida las credenciales y devuelve el usuario autenticado.
  Future<Usuario> iniciarSesion({
    required String correo,
    required String password,
  });

  /// Crea la cuenta y devuelve el usuario registrado.
  Future<Usuario> registrar({
    required String nombre,
    required String correo,
    required String password,
  });

  /// "Envía" el correo de recuperación de contraseña.
  Future<void> enviarEnlaceRecuperacion(String correo);

  /// Cierra la sesión del usuario.
  Future<void> cerrarSesion();
}
