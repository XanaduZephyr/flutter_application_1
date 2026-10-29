import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/domain/usecases/enviar_enlace_recuperacion.dart';
import 'package:flutter_application_1/domain/usecases/iniciar_sesion.dart';
import 'package:flutter_application_1/domain/usecases/registrar_usuario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_state.dart';

/// Gestiona el estado de la autenticación (login, registro y recuperación).
///
/// La UI solo escucha este cubit: no hace `Future.delayed` ni llama a la capa
/// de datos directamente.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.casoIniciarSesion,
    required this.casoRegistrarUsuario,
    required this.casoEnviarEnlace,
  }) : super(const AuthState());

  final IniciarSesion casoIniciarSesion;
  final RegistrarUsuario casoRegistrarUsuario;
  final EnviarEnlaceRecuperacion casoEnviarEnlace;

  /// Inicia sesión y emite [EstadoAuth.autenticado] o [EstadoAuth.error].
  Future<void> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    emit(state.copyWith(estado: EstadoAuth.cargando, limpiarMensaje: true));

    try {
      final usuario = await casoIniciarSesion(
        correo: correo,
        password: password,
      );
      emit(
        state.copyWith(
          estado: EstadoAuth.autenticado,
          usuario: usuario,
          mensaje: 'Bienvenido ${usuario.nombre}',
        ),
      );
    } on Failure catch (error) {
      emit(state.copyWith(estado: EstadoAuth.error, mensaje: error.mensaje));
    } catch (_) {
      emit(
        state.copyWith(
          estado: EstadoAuth.error,
          mensaje: 'Ocurrió un error inesperado',
        ),
      );
    }
  }

  /// Registra un usuario nuevo.
  Future<void> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    emit(state.copyWith(estado: EstadoAuth.cargando, limpiarMensaje: true));

    try {
      final usuario = await casoRegistrarUsuario(
        nombre: nombre,
        correo: correo,
        password: password,
      );
      emit(
        state.copyWith(
          estado: EstadoAuth.registrado,
          usuario: usuario,
          mensaje: 'Cuenta creada correctamente',
        ),
      );
    } on Failure catch (error) {
      emit(state.copyWith(estado: EstadoAuth.error, mensaje: error.mensaje));
    } catch (_) {
      emit(
        state.copyWith(
          estado: EstadoAuth.error,
          mensaje: 'Ocurrió un error inesperado',
        ),
      );
    }
  }

  /// Pide el enlace de recuperación de contraseña.
  Future<void> enviarEnlace(String correo) async {
    emit(state.copyWith(estado: EstadoAuth.cargando, limpiarMensaje: true));

    try {
      await casoEnviarEnlace(correo);
      emit(
        state.copyWith(
          estado: EstadoAuth.enlaceEnviado,
          mensaje: 'Se envió un enlace de recuperación a $correo',
        ),
      );
    } on Failure catch (error) {
      emit(state.copyWith(estado: EstadoAuth.error, mensaje: error.mensaje));
    } catch (_) {
      emit(
        state.copyWith(
          estado: EstadoAuth.error,
          mensaje: 'Ocurrió un error inesperado',
        ),
      );
    }
  }

  /// Vuelve al estado inicial (cierra la sesión).
  void cerrarSesion() {
    emit(const AuthState());
  }
}
