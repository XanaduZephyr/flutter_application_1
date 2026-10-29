/// Reglas de validación que comparten los formularios (login, registro...).
///
/// Son funciones normales: reciben el texto del campo y devuelven el mensaje
/// de error, o `null` si el valor está bien. Al estar fuera de las pantallas
/// no se repite la misma regla en cada archivo y se pueden probar aparte
/// (ver `test/validadores_test.dart`).
library;

/// Formato básico de correo: algo@algo.algo
final RegExp _patronCorreo = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');

/// El campo no puede quedar vacío.
String? requerido(
  String? valor, [
  String mensaje = 'Este campo es obligatorio',
]) {
  if ((valor ?? '').trim().isEmpty) return mensaje;
  return null;
}

/// El correo debe tener un formato válido.
String? correo(String? valor) {
  final texto = (valor ?? '').trim();
  if (texto.isEmpty) return 'Ingresa tu correo';
  if (!_patronCorreo.hasMatch(texto)) return 'Correo no válido';
  return null;
}

/// El texto debe tener al menos [minimo] caracteres.
String? minimo(String? valor, int minimo) {
  if ((valor ?? '').length < minimo) return 'Mínimo $minimo caracteres';
  return null;
}

/// El texto debe ser igual a [otro] (por ejemplo, confirmar la contraseña).
String? igualA(
  String? valor,
  String otro, {
  String mensaje = 'Los valores no coinciden',
}) {
  if ((valor ?? '') != otro) return mensaje;
  return null;
}
