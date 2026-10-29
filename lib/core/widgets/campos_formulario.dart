import 'package:flutter/material.dart';

/// Campo de texto normal del formulario (nombre, correo, etc.).
///
/// Evita repetir en cada pantalla el `InputDecoration` y el `border`.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.controlador,
    required this.etiqueta,
    required this.icono,
    this.tipoTeclado,
    this.validar,
    this.capitalizar = false,
  });

  /// Controlador que guarda lo que escribe el usuario.
  final TextEditingController controlador;

  /// Texto que aparece dentro del campo.
  final String etiqueta;

  /// Icono que se muestra a la izquierda.
  final IconData icono;

  /// Tipo de teclado (correo, número, texto...).
  final TextInputType? tipoTeclado;

  /// Regla de validación: devuelve el error o `null`.
  final String? Function(String?)? validar;

  /// Si es `true`, pone en mayúscula la primera letra de cada palabra.
  final bool capitalizar;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: tipoTeclado,
      textCapitalization: capitalizar
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        border: const OutlineInputBorder(),
      ),
      validator: validar,
    );
  }
}

/// Campo de contraseña con el botón para mostrar/ocultar el texto.
///
/// Es `StatefulWidget` porque el "ojo" cambia un estado interno
/// ([_ocultar]); la pantalla que lo usa no necesita saber nada de eso.
class CampoContrasena extends StatefulWidget {
  const CampoContrasena({
    super.key,
    required this.controlador,
    this.etiqueta = 'Contraseña',
    this.validar,
  });

  final TextEditingController controlador;
  final String etiqueta;
  final String? Function(String?)? validar;

  @override
  State<CampoContrasena> createState() => _CampoContrasenaState();
}

class _CampoContrasenaState extends State<CampoContrasena> {
  bool _ocultar = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      obscureText: _ocultar,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: _ocultar ? 'Mostrar contraseña' : 'Ocultar contraseña',
          icon: Icon(
            _ocultar
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _ocultar = !_ocultar;
            });
          },
        ),
      ),
      validator: widget.validar,
    );
  }
}

/// Botón ancho que se usa para enviar el formulario.
///
/// Si [cargando] es `true` muestra un indicador circular y se deshabilita
/// (para que el usuario no envíe el formulario dos veces).
class BotonPrincipal extends StatelessWidget {
  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: cargando ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: cargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(texto),
        ),
      ),
    );
  }
}
