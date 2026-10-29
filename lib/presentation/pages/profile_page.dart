import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/routes/app_routes.dart';

/// Perfil del usuario: avatar, nombre, correo y botón para cerrar sesión.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.nombre = AppConstants.usuarioDemo,
    this.correo = AppConstants.correoDemo,
  });

  final String nombre;
  final String correo;

  void _cerrarSesion(BuildContext context) {
    // 1. Se limpia el estado de autenticación en el cubit
    context.read<AuthCubit>().cerrarSesion();

    // 2. `pushNamedAndRemoveUntil` con `(route) => false` destruye todo el
    //    historial: no se puede volver atrás con el botón del navegador.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar genérico
            const CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              nombre,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              correo,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Divider(height: 32),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.badge_outlined, color: AppColors.primary),
              title: Text('Rol'),
              subtitle: Text('Usuario'),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.verified_user_outlined,
                color: AppColors.primary,
              ),
              title: Text('Estado'),
              subtitle: Text('Activo'),
            ),
            const SizedBox(height: 24),
            // Botón rojo para cerrar sesión
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _cerrarSesion(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
