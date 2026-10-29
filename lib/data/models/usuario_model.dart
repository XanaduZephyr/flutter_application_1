/// Modelo de datos (DTO) que representa exactamente el JSON que devolvería la
/// API de UserMaster. Vive en `data/` y nunca se usa directamente en la UI.
class UsuarioModel {
  const UsuarioModel({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  /// Construye el modelo desde un JSON.
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
    );
  }

  final String id;
  final String nombre;
  final String correo;

  /// Convierte el modelo a JSON (útil para guardarlo o enviarlo).
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
  };
}
