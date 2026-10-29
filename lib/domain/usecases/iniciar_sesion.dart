import 'package:flutter_application_1/domain/entities/usuario.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

/// Caso de uso: iniciar sesión con correo y contraseña.
class IniciarSesion {
  const IniciarSesion(this._repositorio);

  final AuthRepository _repositorio;

  Future<Usuario> call({required String correo, required String password}) {
    return _repositorio.iniciarSesion(correo: correo, password: password);
  }
}
