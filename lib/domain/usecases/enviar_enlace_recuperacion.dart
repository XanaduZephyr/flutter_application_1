import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

/// Caso de uso: pedir el enlace de recuperación de contraseña.
class EnviarEnlaceRecuperacion {
  const EnviarEnlaceRecuperacion(this._repositorio);

  final AuthRepository _repositorio;

  Future<void> call(String correo) {
    return _repositorio.enviarEnlaceRecuperacion(correo);
  }
}
