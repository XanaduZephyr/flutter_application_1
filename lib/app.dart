import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/themes/app_theme.dart';
import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/usecases/enviar_enlace_recuperacion.dart';
import 'package:flutter_application_1/domain/usecases/iniciar_sesion.dart';
import 'package:flutter_application_1/domain/usecases/registrar_usuario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Configuración principal de UserMaster: tema, rutas e inyección de
/// dependencias (data -> domain -> presentation).
class UserMasterApp extends StatelessWidget {
  const UserMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      // Implementación real del repositorio (capa de datos)
      create: (_) => AuthRepositoryImpl(AuthLocalDataSource()),
      child: BlocProvider<AuthCubit>(
        create: (context) {
          final repositorio = context.read<AuthRepository>();

          return AuthCubit(
            casoIniciarSesion: IniciarSesion(repositorio),
            casoRegistrarUsuario: RegistrarUsuario(repositorio),
            casoEnviarEnlace: EnviarEnlaceRecuperacion(repositorio),
          );
        },
        child: MaterialApp(
          title: AppConstants.nombreApp,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.claro,
          // '/' es la pantalla inicial: el splash
          initialRoute: AppRoutes.splash,
          routes: appRoutes,
        ),
      ),
    );
  }
}
