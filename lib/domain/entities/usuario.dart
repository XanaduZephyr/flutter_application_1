/// Entidad de dominio que representa a un usuario de UserMaster.
class Usuario {
  const Usuario({required this.id, required this.nombre, required this.correo});

  final String id;
  final String nombre;
  final String correo;

  /// Iniciales para el avatar. Ej: "Ana López" => "AL".
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));

    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();

    final primera = partes.first.substring(0, 1);
    final ultima = partes.last.substring(0, 1);
    return '$primera$ultima'.toUpperCase();
  }
}
