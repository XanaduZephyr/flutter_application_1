import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/usecases/enviar_enlace_recuperacion.dart';
import 'package:flutter_application_1/domain/usecases/iniciar_sesion.dart';
import 'package:flutter_application_1/domain/usecases/registrar_usuario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Utilidades compartidas por las pruebas de widgets.
///
/// Monta la app con las dependencias reales (repositorio + cubit) pero con una
/// fuente de datos sin retardo, para que los tests sean instantáneos.

/// Envuelve [app] con el repositorio y el cubit que necesitan las pantallas.
Widget _conDependencias(Widget app, Duration retardo) {
  final repositorio = AuthRepositoryImpl(
    AuthLocalDataSource(tiempoDeEspera: retardo),
  );

  return RepositoryProvider<AuthRepository>.value(
    value: repositorio,
    child: BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(
        casoIniciarSesion: IniciarSesion(repositorio),
        casoRegistrarUsuario: RegistrarUsuario(repositorio),
        casoEnviarEnlace: EnviarEnlaceRecuperacion(repositorio),
      ),
      child: app,
    ),
  );
}

/// App con una sola pantalla (sin rutas), para probar una página aislada.
Widget appConPantalla(Widget pantalla, {Duration retardo = Duration.zero}) {
  return _conDependencias(MaterialApp(home: pantalla), retardo);
}

/// App con todas las rutas registradas, para probar navegación entre pantallas.
Widget appConRutas({
  String rutaInicial = AppRoutes.login,
  Duration retardo = Duration.zero,
}) {
  return _conDependencias(
    MaterialApp(initialRoute: rutaInicial, routes: appRoutes),
    retardo,
  );
}
