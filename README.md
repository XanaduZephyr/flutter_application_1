# UserMaster — Flutter + Clean Architecture

App móvil (Flutter Web incluido) con el flujo completo de autenticación y un
dashboard básico. Proyecto del **Taller 2**: UI + navegación implementadas con
**Clean Architecture** (capas `presentation`, `domain` y `data`), sin backend
real: la "API" se simula con `Future.delayed` y repositorios locales.

🔗 **App desplegada:** <https://xanaduzephyr.github.io/flutter_application_1/>

## Descripción

UserMaster permite registrarse, iniciar sesión, recuperar la contraseña, ver un
dashboard con elementos recientes y cerrar sesión desde el perfil. Toda la
interfaz está en español y el código está separado por capas para que sea fácil
de leer, probar y mantener.

## Objetivos

- Implementar las pantallas y la navegación del flujo de autenticación.
- Aplicar **Clean Architecture** en Flutter: la UI nunca conoce la fuente de
  datos; el dominio define entidades, contratos y casos de uso.
- Extraer los elementos comunes a `widgets/` para no duplicar código.
- Centralizar la navegación en `routes/` y la paleta en `app_colors.dart`.
- Simular las llamadas al backend con `Future.delayed` + estados de carga.
- Cubrir las capas con pruebas automatizadas (`test/domain`, `test/data`,
  `test/presentation`, `test/utils`).

## Pantallas y flujos

| Pantalla | Archivo | Qué hace |
|---|---|---|
| Splash | `splash_page.dart` | Logo centrado con el color principal; **3 s** y pasa al login |
| Login | `login_page.dart` | Correo + contraseña, botón **Ingresar** con carga de **2 s**, enlaces a registro y recuperación |
| Registro | `register_page.dart` | Nombre, correo, contraseña y confirmación (**deben coincidir**), términos y vuelta al login |
| Recuperar contraseña | `forgot_password_page.dart` | Correo + **SnackBar** confirmando el envío del enlace |
| Dashboard | `dashboard_page.dart` | `BottomNavigationBar` (Inicio/Perfil), "Hola, Usuario" y 6 tarjetas recientes |
| Perfil | `profile_page.dart` | Avatar, nombre, correo y botón rojo **Cerrar sesión** (destruye el historial) |

## Tech Stack

| Herramienta | Uso |
|---|---|
| **Flutter 3.47.7** / **Dart 3.13.5** | Framework y lenguaje |
| **flutter_bloc** (`Cubit`) | Gestión del estado de autenticación |
| **Material 3** | Componentes visuales |
| `flutter_lints` | Reglas de estilo (0 issues en `flutter analyze`) |
| `flutter_test` | 32 pruebas de widgets, dominio y datos |
| **Rutas nombradas** (`Navigator.pushNamed`) | Navegación centralizada en `routes/` |
| **GitHub Pages + Actions** | Despliegue web (CI/CD) |

## Estructura del proyecto (Clean Architecture)

```
lib/
├── app.dart                          # MaterialApp + tema + rutas + providers
├── main.dart                         # Solo runApp()
│
├── core/                             # Recursos compartidos
│   ├── constants/app_constants.dart   # Nombre, tiempos, longitudes mínimas
│   ├── errors/failures.dart           # Failure / AuthFailure / NetworkFailure
│   ├── network/api_config.dart        # Configuración de la "API" simulada
│   ├── themes/app_colors.dart         # Paleta de colores
│   ├── themes/app_theme.dart          # ThemeData (Material 3)
│   ├── utils/validadores.dart         # Reglas de validación reutilizables
│   └── widgets/                       # Widgets reutilizables
│       ├── campos_formulario.dart     # CampoTexto, CampoContrasena, BotonPrincipal
│       ├── fondo_app.dart             # Fondo con imagen
│       └── pantalla_formulario.dart   # Carcasa común de los formularios
│
├── domain/                           # Reglas de negocio (no depende de nadie)
│   ├── entities/usuario.dart          # Entidad Usuario
│   ├── exceptions/auth_exception.dart # Excepción del dominio
│   ├── repositories/auth_repository.dart   # Interfaz (contrato)
│   └── usecases/
│       ├── iniciar_sesion.dart
│       ├── registrar_usuario.dart
│       └── enviar_enlace_recuperacion.dart
│
├── data/                             # Implementación de los datos
│   ├── datasources/auth_local_datasource.dart  # Simula la API (Future.delayed)
│   ├── models/usuario_model.dart               # DTO (JSON)
│   ├── mappers/usuario_mapper.dart             # Model -> Entidad
│   └── repositories/auth_repository_impl.dart  # Implementa el contrato
│
└── presentation/                     # UI + estado
    ├── blocs/auth_cubit.dart          # Lógica de estado (flutter_bloc)
    ├── blocs/auth_state.dart          # Estados e info para la UI
    ├── pages/                         # Las 6 pantallas
    ├── routes/app_routes.dart         # Nombres y mapa de rutas
    └── widgets/tarjeta_reciente.dart  # Widget propio del dashboard

test/
├── data/auth_repository_impl_test.dart   # Repositorio + modelo
├── domain/auth_usecases_test.dart        # Casos de uso + entidad
├── presentation/                         # Una prueba por pantalla
│   ├── splash_page_test.dart
│   ├── login_page_test.dart
│   ├── register_page_test.dart
│   ├── forgot_password_page_test.dart
│   └── dashboard_page_test.dart
└── utils/
    ├── test_app.dart                     # Helper con providers
    └── validadores_test.dart             # Reglas de validación
```

### Flujo de una acción (ej. iniciar sesión)

```
LoginPage  →  AuthCubit  →  IniciarSesion (use case)  →  AuthRepository (interfaz)
                                                              ↑ implementa
                                              AuthRepositoryImpl  →  AuthLocalDataSource (Future.delayed)
                                              UsuarioModel + mapper → entidad Usuario
```

## Rutas

| Nombre (`AppRoutes`) | Ruta | Pantalla |
|---|---|---|
| `splash` | `/` | `SplashPage` |
| `login` | `/login` | `LoginPage` |
| `register` | `/register` | `RegisterPage` |
| `forgotPassword` | `/forgot-password` | `ForgotPasswordPage` |
| `dashboard` | `/dashboard` | `DashboardPage` |

## Cómo ejecutar

```bash
flutter pub get
flutter run -d chrome        # o flutter run -d emulator-5554
```

## Pruebas y análisis

```bash
flutter analyze     # 0 issues
flutter test        # 32 pruebas
```

## Despliegue

- **GitHub Pages:** <https://xanaduzephyr.github.io/flutter_application_1/>
- El sitio se publica desde la rama `gh-pages` (build de `flutter build web`).
- El workflow de **GitHub Actions** (`.github/workflows/deploy.yml`) corre
  `flutter analyze`, `flutter test` y `flutter build web --base-href /flutter_application_1/`
  para desplegar automáticamente en cada push a `main`.

## Autor

- **XanaduZephyr** — [@XanaduZephyr](https://github.com/XanaduZephyr)
