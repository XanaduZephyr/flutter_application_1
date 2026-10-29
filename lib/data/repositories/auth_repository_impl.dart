import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/data/mappers/usuario_mapper.dart';
import 'package:flutter_application_1/data/models/usuario_model.dart';
import 'package:flutter_application_1/domain/entities/usuario.dart';
import 'package:flutter_application_1/domain/exceptions/auth_exception.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

/// Implementación del repositorio de autenticación.
///
/// Pide los JSON a [AuthLocalDataSource], los pasa por [UsuarioModel] y los
/// devuelve como entidades [Usuario]. Los errores de dominio
/// ([AuthException]) se transforman en [AuthFailure] para la UI.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._fuenteLocal);

  final AuthLocalDataSource _fuenteLocal;

  @override
  Future<Usuario> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    try {
      final json = await _fuenteLocal.iniciarSesion(
        correo: correo,
        password: password,
      );
      return UsuarioModel.fromJson(json).aEntidad();
    } on AuthException catch (error) {
      throw AuthFailure(error.mensaje);
    }
  }

  @override
  Future<Usuario> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final json = await _fuenteLocal.registrar(
        nombre: nombre,
        correo: correo,
        password: password,
      );
      return UsuarioModel.fromJson(json).aEntidad();
    } on AuthException catch (error) {
      throw AuthFailure(error.mensaje);
    }
  }

  @override
  Future<void> enviarEnlaceRecuperacion(String correo) async {
    try {
      await _fuenteLocal.enviarEnlaceRecuperacion(correo);
    } on AuthException catch (error) {
      throw AuthFailure(error.mensaje);
    }
  }

  @override
  Future<void> cerrarSesion() async {
    // En esta simulación no hay tokens que invalidar.
  }
}
