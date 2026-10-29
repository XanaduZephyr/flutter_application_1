import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/network/api_config.dart';
import 'package:flutter_application_1/domain/exceptions/auth_exception.dart';

/// Fuente de datos local que **simula** la API de UserMaster.
///
/// Cada método espera [tiempoDeEspera] (2 segundos por defecto) con
/// `Future.delayed` y devuelve mapas JSON, igual que lo haría una petición
/// HTTP real. Los usuarios registrados se guardan en memoria.
class AuthLocalDataSource {
  AuthLocalDataSource({this.tiempoDeEspera = ApiConfig.tiempoDeEspera});

  /// Tiempo que "tarda" cada llamada (se puede bajar en las pruebas).
  final Duration tiempoDeEspera;

  /// Usuarios registrados en memoria: correo -> datos.
  final Map<String, Map<String, String>> _usuarios = {};

  /// Simula `POST /auth/login`.
  Future<Map<String, dynamic>> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    await Future.delayed(tiempoDeEspera);

    if (password.length < AppConstants.longitudMinimaPassword) {
      throw const AuthException('Correo o contraseña incorrectos');
    }

    final registrado = _usuarios[correo];

    return {
      'id': registrado?['id'] ?? 'u-${correo.hashCode.abs()}',
      'nombre': registrado?['nombre'] ?? _nombreDesdeCorreo(correo),
      'correo': correo,
    };
  }

  /// Simula `POST /auth/register`.
  Future<Map<String, dynamic>> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    await Future.delayed(tiempoDeEspera);

    if (password.length < AppConstants.longitudMinimaPassword) {
      throw const AuthException(
        'La contraseña debe tener al menos 6 caracteres',
      );
    }

    final usuario = {
      'id': 'u-${DateTime.now().millisecondsSinceEpoch}',
      'nombre': nombre,
      'correo': correo,
    };

    _usuarios[correo] = usuario;
    return usuario;
  }

  /// Simula `POST /auth/forgot-password`.
  Future<void> enviarEnlaceRecuperacion(String correo) async {
    await Future.delayed(tiempoDeEspera);

    if (correo.trim().isEmpty) {
      throw const AuthException('Ingresa tu correo');
    }
  }

  /// "ana.lopez@mail.com" => "Ana Lopez"
  String _nombreDesdeCorreo(String correo) {
    final usuario = correo.split('@').first.replaceAll('.', ' ').trim();
    if (usuario.isEmpty) return AppConstants.usuarioDemo;

    return usuario[0].toUpperCase() + usuario.substring(1);
  }
}
