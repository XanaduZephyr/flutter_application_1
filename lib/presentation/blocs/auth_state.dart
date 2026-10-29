import 'package:flutter_application_1/domain/entities/usuario.dart';

/// Estados posibles del proceso de autenticación.
enum EstadoAuth {
  /// Todavía no pasó nada.
  inicial,

  /// Se está esperando la respuesta (muestra el indicador circular).
  cargando,

  /// Login correcto.
  autenticado,

  /// Registro correcto.
  registrado,

  /// Se "envió" el enlace de recuperación.
  enlaceEnviado,

  /// Algo falló (credenciales, red...).
  error,
}

/// Estado que expone `AuthCubit` a la UI.
class AuthState {
  const AuthState({
    this.estado = EstadoAuth.inicial,
    this.usuario,
    this.mensaje,
  });

  final EstadoAuth estado;

  /// Usuario autenticado (null si no hay sesión).
  final Usuario? usuario;

  /// Mensaje para mostrar en un SnackBar.
  final String? mensaje;

  /// Atajo para saber si hay que mostrar el indicador de carga.
  bool get cargando => estado == EstadoAuth.cargando;

  AuthState copyWith({
    EstadoAuth? estado,
    Usuario? usuario,
    String? mensaje,
    bool limpiarMensaje = false,
  }) {
    return AuthState(
      estado: estado ?? this.estado,
      usuario: usuario ?? this.usuario,
      mensaje: limpiarMensaje ? null : (mensaje ?? this.mensaje),
    );
  }
}
