import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

/// Tarjeta que muestra un elemento reciente en el dashboard.
///
/// Vive en `presentation/widgets/` porque es un widget específico de la UI.
class TarjetaReciente extends StatelessWidget {
  const TarjetaReciente({
    super.key,
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.hora,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final String hora;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.10),
          child: Icon(icono, color: AppColors.primary),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(detalle),
        trailing: Text(
          hora,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
