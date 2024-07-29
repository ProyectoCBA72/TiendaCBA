// ignore_for_file: file_names

/// Clase que representa una opción de tipo de documento para editar usuario.
///
/// Esta clase tiene dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado a esa opción.
class TipoDocumentoEditar {
  /// Título de la opción.
  final String? titulo;

  /// Valor asociado a la opción.
  final String? valor;

  /// Constructor que inicializa el título y el valor de la opción.
  ///
  /// Toma dos parámetros obligatorios: [titulo] y [valor].
  TipoDocumentoEditar(this.titulo, this.valor);
}

/// Lista de opciones de tipo de documento para editar usuario.
///
/// Cada opción es una instancia de la clase [TipoDocumentoEditar] que tiene
/// dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado
/// a esa opción.
///
/// Cada opción representa un tipo de documento válido para editar un usuario.
final List options1 = [
  // Opción para tarjeta de identidad
  TipoDocumentoEditar(
    'Tarjeta de Identidad', // Título de la opción
    'TI', // Valor asociado a la opción
  ),
  // Opción para cédula ciudadana
  TipoDocumentoEditar(
    'Cedula Ciudadanía', // Título de la opción
    "CC", // Valor asociado a la opción
  ),
  // Opción para cédula extranjera
  TipoDocumentoEditar(
    'Cedula Extranjería', // Título de la opción
    "CE", // Valor asociado a la opción
  ),
  // Opción para pasaporte
  TipoDocumentoEditar(
    'Pasaporte', // Título de la opción
    "PAS", // Valor asociado a la opción
  ),
  // Opción para número de identificación tributaria
  TipoDocumentoEditar(
    'Número de identificación tributaria', // Título de la opción
    "NIT", // Valor asociado a la opción
  ),
];

/// Clase que representa una opción de rol principal para editar usuario.
///
/// Cada opción es una instancia de la clase [RolPrimerNivelEditar] que tiene
/// dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado
/// a esa opción.
///
/// Cada opción representa un rol principal válido para editar un usuario.
class RolPrimerNivelEditar {
  /// Título de la opción.
  final String? titulo;

  /// Valor asociado a la opción.
  final String? valor;

  /// Constructor que inicializa el título y el valor de la opción.
  ///
  /// El título y el valor son obligatorios y se utilizan para mostrar la opción
  /// en la interfaz de usuario.
  RolPrimerNivelEditar(this.titulo, this.valor);
}

/// Lista que almacena todas las opciones de rol principal válidas para editar un usuario.
///
/// Cada opción es una instancia de la clase [RolPrimerNivelEditar] que tiene
/// dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado
/// a esa opción.
///
/// Cada opción representa un rol principal válido para editar un usuario.
final List rolN1 = [
  RolPrimerNivelEditar("APRENDIZ", 'APRENDIZ'),
  RolPrimerNivelEditar("INSTRUCTOR", 'INSTRUCTOR'),
  RolPrimerNivelEditar("FUNCIONARIO", 'FUNCIONARIO'),
];

/// Clase que representa una opción de rol secundario para editar un usuario.
///
/// Cada opción es una instancia de la clase [RolSegundoNivelEditar] que tiene
/// dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado
/// a esa opción.
///
/// Cada opción representa un rol secundario válido para editar un usuario.
class RolSegundoNivelEditar {
  /// Título de la opción.
  ///
  /// Este atributo es obligatorio y se utiliza para mostrar el título
  /// en la interfaz de usuario.
  final String? titulo;

  /// Valor asociado a la opción.
  ///
  /// Este atributo es obligatorio y se utiliza para asignar un valor
  /// específico a cada opción.
  final String? valor;

  /// Constructor que inicializa el título y el valor de la opción.
  ///
  /// El título y el valor son obligatorios y se utilizan para mostrar la opción
  /// en la interfaz de usuario.
  RolSegundoNivelEditar(this.titulo, this.valor);
}

/// Lista que almacena todas las opciones de rol secundario válido para editar un usuario.
///
/// Esta lista contiene instancias de la clase [RolSegundoNivelEditar] que tienen dos atributos:
/// [titulo] y [valor]. [titulo] es el título a mostrar en la opción y [valor] es el valor asociado
/// a esa opción. Cada opción representa un rol secundario válido para editar un usuario.
///
/// Los elementos de esta lista son de tipo [RolSegundoNivelEditar].
///
/// Ejemplo de uso:
///   // Agregar una opción de rol secundario a la lista
///   rolN2.add(
///     RolSegundoNivelEditar("TUTOR UNIDAD", 'TUTOR'),
///   );
final List rolN2 = [
  /// Opción de rol secundario "TUTOR UNIDAD".
  /// Este rol representa a un tutor de una unidad.
  RolSegundoNivelEditar("TUTOR UNIDAD", 'TUTOR'),

  /// Opción de rol secundario "ADMINISTRADOR PUNTO VENTA".
  /// Este rol representa a un administrador de un punto de venta.
  RolSegundoNivelEditar("ADMINISTRADOR PUNTO VENTA", "PUNTO"),

  /// Opción de rol secundario "VENDEDOR PUNTO VENTA".
  /// Este rol representa a un vendedor de un punto de venta.
  RolSegundoNivelEditar("VENDEDOR PUNTO VENTA", "VENDEDOR"),

  /// Opción de rol secundario "LIDER SENA".
  /// Este rol representa a un líder de una sede.
  RolSegundoNivelEditar("LIDER SENA", 'LIDER'),
];
