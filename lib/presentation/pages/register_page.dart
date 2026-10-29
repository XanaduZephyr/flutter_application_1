import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/utils/validadores.dart';
import 'package:flutter_application_1/core/widgets/campos_formulario.dart';
import 'package:flutter_application_1/core/widgets/pantalla_formulario.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/blocs/auth_state.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Registro de usuario.
///
/// Valida que las contraseñas coincidan, llama al cubit para "registrar" y
/// vuelve al login cuando el registro termina.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _aceptaTerminos = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _crearCuenta() {
    final formularioValido = _formKey.currentState!.validate();

    if (!_aceptaTerminos) {
      _mostrarMensaje('Debes aceptar los términos y condiciones');
      return;
    }

    if (!formularioValido) return;

    context.read<AuthCubit>().registrar(
      nombre: _nombreController.text.trim(),
      correo: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  /// Vuelve al login (o lo abre si esta pantalla se abrió directo).
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
        if (state.estado == EstadoAuth.registrado) {
          _mostrarMensaje(state.mensaje ?? 'Cuenta creada correctamente');
          _volverAlLogin();
        } else if (state.estado == EstadoAuth.error && state.mensaje != null) {
          _mostrarMensaje(state.mensaje!);
        }
      },
      builder: (context, state) {
        return PantallaFormulario(
          titulo: 'Registro',
          formKey: _formKey,
          children: [
            const Icon(Icons.person_add_alt_1, size: 80),
            const SizedBox(height: 24),

            // Nombre completo
            CampoTexto(
              controlador: _nombreController,
              etiqueta: 'Nombre completo',
              icono: Icons.person_outline,
              capitalizar: true,
              validar: (valor) =>
                  requerido(valor, 'Ingresa tu nombre') ?? minimo(valor, 3),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Confirmar contraseña (debe coincidir)
            CampoContrasena(
              controlador: _confirmarController,
              etiqueta: 'Confirmar contraseña',
              validar: (valor) {
                final error = requerido(valor, 'Confirma tu contraseña');
                if (error != null) return error;

                return igualA(
                  valor,
                  _passwordController.text,
                  mensaje: 'Las contraseñas no coinciden',
                );
              },
            ),
            const SizedBox(height: 8),

            // Términos y condiciones
            CheckboxListTile(
              value: _aceptaTerminos,
              onChanged: state.cargando
                  ? null
                  : (valor) {
                      setState(() {
                        _aceptaTerminos = valor ?? false;
                      });
                    },
              title: const Text('Acepto los términos y condiciones'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),

            // Botón principal
            BotonPrincipal(
              texto: 'Crear cuenta',
              cargando: state.cargando,
              onPressed: _crearCuenta,
            ),
            const SizedBox(height: 8),

            // Volver al login
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: state.cargando ? null : _volverAlLogin,
                  child: const Text('Inicia sesión'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
