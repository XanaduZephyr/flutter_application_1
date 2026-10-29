import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/utils/validadores.dart';
import 'package:flutter_application_1/core/widgets/campos_formulario.dart';
import 'package:flutter_application_1/core/widgets/pantalla_formulario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/blocs/auth_state.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Recuperar contraseña.
///
/// Pide el correo y el cubit "envía" el enlace; cuando termina se muestra un
/// [SnackBar] confirmando el envío.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _enviarEnlace() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().enviarEnlace(_emailController.text.trim());
  }

  /// Regresa al login (o lo abre si esta pantalla se abrió directo).
  void _volverAlLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.estado == EstadoAuth.enlaceEnviado) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.mensaje ?? 'Enlace enviado')),
          );
        } else if (state.estado == EstadoAuth.error && state.mensaje != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.mensaje!)));
        }
      },
      builder: (context, state) {
        return PantallaFormulario(
          titulo: 'Recuperar contraseña',
          formKey: _formKey,
          children: [
            const Icon(Icons.lock_reset, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Escribe tu correo y te enviaremos un enlace para restablecer '
              'tu contraseña.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Correo electrónico
            CampoTexto(
              controlador: _emailController,
              etiqueta: 'Correo electrónico',
              icono: Icons.email_outlined,
              tipoTeclado: TextInputType.emailAddress,
              validar: correo,
            ),
            const SizedBox(height: 24),

            // Botón principal
            BotonPrincipal(
              texto: 'Enviar enlace de recuperación',
              cargando: state.cargando,
              onPressed: _enviarEnlace,
            ),
            const SizedBox(height: 8),

            // Volver al login
            TextButton(
              onPressed: state.cargando ? null : _volverAlLogin,
              child: const Text('Volver al inicio de sesión'),
            ),
          ],
        );
      },
    );
  }
}
