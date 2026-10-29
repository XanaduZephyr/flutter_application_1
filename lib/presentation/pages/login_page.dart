import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/utils/validadores.dart';
import 'package:flutter_application_1/core/widgets/campos_formulario.dart';
import 'package:flutter_application_1/core/widgets/pantalla_formulario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/blocs/auth_state.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Inicio de sesión.
///
/// La carga de 2 segundos la simula la capa de datos (`Future.delayed`) y el
/// estado lo maneja `AuthCubit`: la página solo lee y muestra ese estado.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    // Si algún campo no es válido, no se llama al cubit
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().iniciarSesion(
      correo: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.estado == EstadoAuth.autenticado) {
          // pushReplacement: no se puede volver al login con "atrás"
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        } else if (state.estado == EstadoAuth.error && state.mensaje != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.mensaje!)));
        }
      },
      builder: (context, state) {
        return PantallaFormulario(
          titulo: 'Iniciar sesión',
          formKey: _formKey,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 24),

            // Correo electrónico
            CampoTexto(
              controlador: _emailController,
              etiqueta: 'Correo electrónico',
              icono: Icons.email_outlined,
              tipoTeclado: TextInputType.emailAddress,
              validar: correo,
            ),
            const SizedBox(height: 16),

            // Contraseña
            CampoContrasena(
              controlador: _passwordController,
              validar: (valor) =>
                  requerido(valor, 'Ingresa tu contraseña') ?? minimo(valor, 6),
            ),

            // Enlace a recuperar contraseña
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: state.cargando
                    ? null
                    : () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),
            const SizedBox(height: 8),

            // Botón con el indicador circular mientras carga
            BotonPrincipal(
              texto: 'Ingresar',
              cargando: state.cargando,
              onPressed: _iniciarSesion,
            ),
            const SizedBox(height: 8),

            // Enlace al registro
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('¿No tienes cuenta?'),
                TextButton(
                  onPressed: state.cargando
                      ? null
                      : () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
