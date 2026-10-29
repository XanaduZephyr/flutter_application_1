import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';
import 'package:flutter_application_1/presentation/blocs/auth_cubit.dart';
import 'package:flutter_application_1/presentation/pages/profile_page.dart';
import 'package:flutter_application_1/presentation/widgets/tarjeta_reciente.dart';

/// Dashboard principal de UserMaster.
///
/// Tiene un [BottomNavigationBar] con dos pestañas: **Inicio** (saludo +
/// listado de elementos recientes) y **Perfil**.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Pestaña actual: 0 = Inicio, 1 = Perfil.
  int _indice = 0;

  static const List<String> _titulos = ['Inicio', 'Perfil'];

  @override
  Widget build(BuildContext context) {
    // Usuario autenticado (lo guarda el cubit al hacer login)
    final usuario = context.watch<AuthCubit>().state.usuario;

    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indice])),
      body: IndexedStack(
        index: _indice,
        children: [
          const _InicioTab(),
          ProfilePage(
            nombre: usuario?.nombre ?? AppConstants.usuarioDemo,
            correo: usuario?.correo ?? AppConstants.correoDemo,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (indice) {
          setState(() {
            _indice = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Un elemento del listado "recientes" (datos de ejemplo).
class ElementoReciente {
  const ElementoReciente({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.hora,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final String hora;
}

/// Datos de ejemplo: en una app real vendrían de un caso de uso.
const List<ElementoReciente> elementosRecientes = [
  ElementoReciente(
    icono: Icons.notifications_active_outlined,
    titulo: 'Nueva notificación',
    detalle: 'Tienes un mensaje sin leer',
    hora: 'Hace 5 min',
  ),
  ElementoReciente(
    icono: Icons.task_alt_outlined,
    titulo: 'Tarea completada',
    detalle: 'Terminaste "Diseñar el login"',
    hora: 'Hace 30 min',
  ),
  ElementoReciente(
    icono: Icons.event_available_outlined,
    titulo: 'Reunión programada',
    detalle: 'Mañana a las 9:00 a. m.',
    hora: 'Hace 1 h',
  ),
  ElementoReciente(
    icono: Icons.folder_open_outlined,
    titulo: 'Archivo compartido',
    detalle: 'Ana compartió "presupuesto.pdf"',
    hora: 'Hace 2 h',
  ),
  ElementoReciente(
    icono: Icons.thumb_up_alt_outlined,
    titulo: 'Nuevo "me gusta"',
    detalle: 'A 3 personas les gustó tu publicación',
    hora: 'Ayer',
  ),
  ElementoReciente(
    icono: Icons.verified_user_outlined,
    titulo: 'Contraseña actualizada',
    detalle: 'Tu cuenta está protegida',
    hora: 'Ayer',
  ),
];

/// Pestaña de Inicio: saludo + listado de tarjetas.
class _InicioTab extends StatelessWidget {
  const _InicioTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hola, Usuario',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Estos son tus elementos recientes',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        // Una tarjeta por cada elemento (6 en total)
        for (final elemento in elementosRecientes)
          TarjetaReciente(
            icono: elemento.icono,
            titulo: elemento.titulo,
            detalle: elemento.detalle,
            hora: elemento.hora,
          ),
      ],
    );
  }
}
