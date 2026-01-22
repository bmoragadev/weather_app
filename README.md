# MiniWeather

MiniWeather es un proyecto personal desarrollado en Flutter que proporciona una interfaz sencilla y eficiente para consultar el clima actual. La aplicación también muestra pronósticos por hora y las condiciones meteorológicas para los próximos 3 días, incluyendo temperaturas mínimas y máximas.

## Características

- **Clima Actual**: Obtén información precisa sobre el clima en tu ubicación actual.
- **Pronóstico por Hora**: Visualiza cambios de temperatura y condiciones climáticas hora a hora.
- **Pronóstico de 3 Días**: Planifica con antelación con un resumen del clima para los próximos días.
- **Tema Claro/Oscuro**: Soporte para temas claro y oscuro, adaptándose a la configuración de tu sistema.
- **Gestión de Permisos**: Manejo robusto de permisos de ubicación.
- **Internacionalización**: Soporte multi-idioma (configurado con `flutter_localizations`).

## Tecnologías Utilizadas

El proyecto sigue los principios de **Clean Architecture** y utiliza las siguientes tecnologías y paquetes clave:

- **[Flutter](https://flutter.dev/)**: Framework principal.
- **[Flutter Riverpod](https://riverpod.dev/)**: Gestión de estado reactiva y eficiente.
- **[GoRouter](https://pub.dev/packages/go_router)**: Gestión de rutas y navegación.
- **[Dio](https://pub.dev/packages/dio)**: Cliente HTTP para realizar peticiones a la API de clima.
- **[Geolocator](https://pub.dev/packages/geolocator)** & **[Geocoding](https://pub.dev/packages/geocoding)**: Servicios de geolocalización.
- **[Shared Preferences](https://pub.dev/packages/shared_preferences)**: Almacenamiento local persistente.
- **[Animate Do](https://pub.dev/packages/animate_do)** & **[Shimmer](https://pub.dev/packages/shimmer)**: Animaciones y efectos de carga.

## Configuración y Ejecución

### Requisitos Previos

- Flutter SDK (versión recomendada: >=3.4.3 <4.0.0)
- Dart SDK
- Un editor de código (VS Code, Android Studio, etc.)

### Instalación

1.  **Clonar el repositorio**:

    ```bash
    git clone https://github.com/tu-usuario/miniweather.git
    cd miniweather
    ```

2.  **Configurar Variables de Entorno**:

    Crea un archivo `.env` en la raíz del proyecto basándote en el archivo `.env.template`. Deberás obtener una API Key de [WeatherAPI](https://www.weatherapi.com/) (o el proveedor que corresponda según la configuración).

    ```env
    WEATHERAPI_KEY=tu_api_key_aqui
    WEATHERAPI_BASE_URL="http://api.weatherapi.com/v1"
    ```

3.  **Instalar Dependencias**:

    ```bash
    flutter pub get
    ```

4.  **Generar Archivos de Traducción (si es necesario)**:

    ```bash
    flutter gen-l10n
    ```

5.  **Ejecutar la Aplicación**:

    ```bash
    flutter run
    ```

## Estructura del Proyecto

El proyecto está organizado siguiendo Clean Architecture dentro de `lib/`:

- `config`: Configuraciones globales, constantes, rutas y temas.
- `domain`: Entidades y definiciones de repositorios (lógica de negocio abstracta).
- `infrastructure`: Implementación de repositorios, datasources y mappers.
- `presentation`: Pantallas (screens), widgets y proveedores de estado (providers).
- `l10n`: Archivos de internacionalización.

## Contribución

Las contribuciones son bienvenidas. Por favor, abre un issue o envía un pull request para mejoras o correcciones.
