import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/data/models/usuario_model.dart';
import 'package:flutter_application_1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthRepositoryImpl repositorio;

  setUp(() {
    // Sin retardo para que las pruebas sean instantáneas
    repositorio = AuthRepositoryImpl(
      AuthLocalDataSource(tiempoDeEspera: Duration.zero),
    );
  });

  test('iniciarSesion devuelve una entidad Usuario', () async {
    final usuario = await repositorio.iniciarSesion(
      correo: 'ana.lopez@mail.com',
      password: '123456',
    );

    expect(usuario.correo, 'ana.lopez@mail.com');
    expect(usuario.nombre, 'Ana lopez');
    expect(usuario.id, isNotEmpty);
  });

  test('iniciarSesion con contraseña corta lanza AuthFailure', () async {
    await expectLater(
      repositorio.iniciarSesion(correo: 'ana@mail.com', password: '123'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('registrar guarda el usuario y el login lo recupera', () async {
    final creado = await repositorio.registrar(
      nombre: 'Ana López',
      correo: 'ana@mail.com',
      password: '123456',
    );
    expect(creado.nombre, 'Ana López');

    final logueado = await repositorio.iniciarSesion(
      correo: 'ana@mail.com',
      password: '123456',
    );
    expect(logueado.nombre, 'Ana López');
  });

  test('enviarEnlaceRecuperacion se completa sin errores', () async {
    await repositorio.enviarEnlaceRecuperacion('ana@mail.com');
  });

  test('UsuarioModel convierte desde y hacia JSON', () {
    final modelo = UsuarioModel.fromJson({
      'id': 'u-1',
      'nombre': 'Ana',
      'correo': 'ana@mail.com',
    });

    expect(modelo.nombre, 'Ana');
    expect(modelo.toJson()['correo'], 'ana@mail.com');
  });
}
