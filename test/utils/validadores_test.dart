import 'package:flutter_application_1/core/utils/validadores.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('requerido', () {
    test('devuelve error cuando el campo está vacío', () {
      expect(requerido(''), 'Este campo es obligatorio');
      expect(requerido('   '), 'Este campo es obligatorio');
      expect(requerido(null), 'Este campo es obligatorio');
    });

    test('acepta un texto normal', () {
      expect(requerido('Ana'), isNull);
    });

    test('permite cambiar el mensaje', () {
      expect(requerido('', 'Ingresa tu nombre'), 'Ingresa tu nombre');
    });
  });

  group('correo', () {
    test('acepta correos con formato válido', () {
      expect(correo('ana@mail.com'), isNull);
      expect(correo('ana.lopez+test@mail.co'), isNull);
      expect(correo('  ana@mail.com  '), isNull); // recorta espacios
    });

    test('rechaza el campo vacío', () {
      expect(correo(''), 'Ingresa tu correo');
      expect(correo(null), 'Ingresa tu correo');
    });

    test('rechaza correos sin formato de correo', () {
      expect(correo('anamail.com'), 'Correo no válido');
      expect(correo('ana@mail'), 'Correo no válido');
    });
  });

  group('minimo', () {
    test('exige la longitud mínima', () {
      expect(minimo('12345', 6), 'Mínimo 6 caracteres');
      expect(minimo('123456', 6), isNull);
    });
  });

  group('igualA', () {
    test('acepta cuando los valores son iguales', () {
      expect(igualA('abc123', 'abc123'), isNull);
    });

    test('rechaza cuando son diferentes', () {
      expect(
        igualA('abc123', 'otra123', mensaje: 'Las contraseñas no coinciden'),
        'Las contraseñas no coinciden',
      );
    });
  });
}
