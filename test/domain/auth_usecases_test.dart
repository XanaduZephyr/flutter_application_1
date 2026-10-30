import 'package:flutter_application_1/domain/entities/usuario.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/usecases/enviar_enlace_recuperacion.dart';
import 'package:flutter_application_1/domain/usecases/iniciar_sesion.dart';
import 'package:flutter_application_1/domain/usecases/registrar_usuario.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repositorio falso: no toca datos, solo anota que fue llamado.
class RepositorioAuthFalso implements AuthRepository {
  bool seLlamoIniciarSesion = false;
  bool seLlamoRegistrar = false;
  String? correoDelEnlace;

  static const Usuario usuario = Usuario(
    id: 'u-1',
    nombre: 'Ana López',
    correo: 'ana@mail.com',
  );

  @override
  Future<Usuario> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    seLlamoIniciarSesion = true;
    return usuario;
  }

  @override
  Future<Usuario> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    seLlamoRegistrar = true;
    return usuario;
  }

  @override
  Future<void> enviarEnlaceRecuperacion(String correo) async {
    correoDelEnlace = correo;
  }

  @override
  Future<void> cerrarSesion() async {}
}

void main() {
  late RepositorioAuthFalso repositorio;

  setUp(() {
    repositorio = RepositorioAuthFalso();
  });

  test('IniciarSesion delega en el repositorio', () async {
    final usuario = await IniciarSesion(repositorio)(
      correo: 'ana@mail.com',
      password: '123456',
    );

    expect(usuario.correo, 'ana@mail.com');
    expect(repositorio.seLlamoIniciarSesion, isTrue);
  });

  test('RegistrarUsuario delega en el repositorio', () async {
    final usuario = await RegistrarUsuario(repositorio)(
      nombre: 'Ana López',
      correo: 'ana@mail.com',
      password: '123456',
    );

    expect(usuario.nombre, 'Ana López');
    expect(repositorio.seLlamoRegistrar, isTrue);
  });

  test('EnviarEnlaceRecuperacion pasa el correo al repositorio', () async {
    await EnviarEnlaceRecuperacion(repositorio)('ana@mail.com');

    expect(repositorio.correoDelEnlace, 'ana@mail.com');
  });

  test('Usuario.iniciales arma las iniciales del avatar', () {
    const dosNombres = Usuario(id: '1', nombre: 'Ana López', correo: 'a@a.com');
    const unNombre = Usuario(id: '2', nombre: 'Ana', correo: 'a@a.com');

    expect(dosNombres.iniciales, 'AL');
    expect(unNombre.iniciales, 'A');
  });
}
