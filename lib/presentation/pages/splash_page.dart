import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Splash Screen.
///
/// Muestra el logo centrado sobre el color principal de la app y, tras
/// exactamente 3 segundos, redirige al inicio de sesión.
///
/// Es adaptativa: escala los tamaños según el ancho (móvil/tablet/escritorio)
/// y cambia de `Column` a `Row` cuando la ventana es más ancha que alta.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Duración exacta del splash (definida en las constantes globales).
  static const Duration duracionSplash = AppConstants.duracionSplash;

  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _temporizador = Timer(duracionSplash, () {
      if (!mounted) return;

      // pushReplacement: el splash sale del historial
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() {
    // Se cancela para no navegar si la pantalla ya se cerró
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color principal de fondo (requisito del splash)
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ancho = constraints.maxWidth;
              final alto = constraints.maxHeight;

              // Móvil / tablet / escritorio
              final escala = _TamanoPantalla.desdeAncho(ancho).escala;

              // Más ancha que alta => logo a la izquierda
              final enHorizontal = ancho > alto;

              final logo = _Logo(escala: escala);
              final carga = _Cargando(escala: escala);

              return Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24 * escala),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          builder: (context, opacidad, hijo) {
                            return Opacity(opacity: opacidad, child: hijo);
                          },
                          child: enHorizontal
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    logo,
                                    SizedBox(width: 40 * escala),
                                    // Flexible: si no cabe, el texto baja
                                    Flexible(child: carga),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    logo,
                                    SizedBox(height: 40 * escala),
                                    carga,
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  // Ayuda de depuración: cambia al redimensionar la ventana
                  if (kDebugMode)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '${_TamanoPantalla.desdeAncho(ancho).name} · '
                          '${ancho.toInt()}×${alto.toInt()} px',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Tamaños de pantalla con su escala (breakpoints de Material: 600 y 1024).
enum _TamanoPantalla {
  movil(escala: 1.0),
  tablet(escala: 1.3),
  escritorio(escala: 1.6);

  const _TamanoPantalla({required this.escala});

  final double escala;

  static _TamanoPantalla desdeAncho(double ancho) {
    if (ancho < 600) return _TamanoPantalla.movil;
    if (ancho < 1024) return _TamanoPantalla.tablet;
    return _TamanoPantalla.escritorio;
  }
}

/// Logo de la app dentro de un círculo.
class _Logo extends StatelessWidget {
  const _Logo({required this.escala});

  final double escala;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24 * escala),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.40),
          width: 2,
        ),
      ),
      child: Icon(Icons.flutter_dash, size: 64 * escala, color: Colors.white),
    );
  }
}

/// Nombre de la app + barra de carga + texto.
class _Cargando extends StatelessWidget {
  const _Cargando({required this.escala});

  final double escala;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppConstants.nombreApp,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24 * escala,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 12 * escala),
        SizedBox(
          width: 160 * escala,
          height: 4 * escala,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
        ),
        SizedBox(height: 12 * escala),
        Text(
          'Cargando...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16 * escala),
        ),
      ],
    );
  }
}
