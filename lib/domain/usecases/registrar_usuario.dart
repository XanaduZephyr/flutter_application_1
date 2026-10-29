import 'package:flutter_application_1/domain/entities/usuario.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

/// Caso de uso: registrar un usuario nuevo.
class RegistrarUsuario {
  const RegistrarUsuario(this._repositorio);

  final AuthRepository _repositorio;

  Future<Usuario> call({
    required String nombre,
    required String correo,
    required String password,
  }) {
    return _repositorio.registrar(
      nombre: nombre,
      correo: correo,
      password: password,
    );
  }
}
