import 'package:flutter_application_1/data/models/usuario_model.dart';
import 'package:flutter_application_1/domain/entities/usuario.dart';

/// Convierte el modelo de datos (`data`) en la entidad del dominio (`domain`).
///
/// Así la UI nunca depende del formato del JSON de la API.
extension UsuarioModelMapper on UsuarioModel {
  Usuario aEntidad() {
    return Usuario(id: id, nombre: nombre, correo: correo);
  }
}
