import 'package:flutter_application_1/core/constants/app_constants.dart';

/// Configuración de la "API" de UserMaster.
///
/// En este taller no existe un backend real: [usarDatosSimulados] indica que la
/// capa de datos responde con datos falsos y [tiempoDeEspera] simula la
/// latencia de la red (`Future.delayed`).
abstract final class ApiConfig {
  /// URL base que usaría la app si tuviera backend.
  static const String baseUrl = 'https://api.usermaster.dev/v1';

  /// Bandera para trabajar con datos simulados (sin backend).
  static const bool usarDatosSimulados = true;

  /// Tiempo que "tarda" cada llamada simulada.
  static const Duration tiempoDeEspera = AppConstants.retardoSimulado;
}
