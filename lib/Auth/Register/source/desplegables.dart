/// Clase que representa una opción de tipo de documento.
///
/// Esta clase tiene dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado a esa opción.
class TipoDocumento {
  /// Título de la opción.
  final String? titulo;

  /// Valor asociado a la opción.
  final String? valor;

  /// Constructor que inicializa el título y el valor de la opción.
  ///
  /// El parámetro [titulo] es el título a mostrar en la opción.
  /// El parámetro [valor] es el valor asociado a esa opción.
  TipoDocumento(this.titulo, this.valor);
}

/// Lista de opciones de tipo de documento.
///
/// Cada opción es una instancia de la clase [TipoDocumento] que tiene
/// dos atributos: [titulo] y [valor].
/// [titulo] es el título a mostrar en la opción y [valor] es el valor asociado a esa opción.
///
/// Cada opción representa un tipo de documento válido para un usuario.
final List options = [
  // Opción para tarjeta de identidad
  TipoDocumento(
    'Tarjeta de Identidad', // Título de la opción
    'TI', // Valor asociado a la opción
  ),
  // Opción para cédula ciudadana
  TipoDocumento(
    'Cedula Ciudadanía', // Título de la opción
    "CC", // Valor asociado a la opción
  ),
  // Opción para cédula extranjera
  TipoDocumento(
    'Cedula Extranjería', // Título de la opción
    "CE", // Valor asociado a la opción
  ),
  // Opción para pasaporte
  TipoDocumento(
    'Pasaporte', // Título de la opción
    "PAS", // Valor asociado a la opción
  ),
  // Opción para número de identificación tributaria
  TipoDocumento(
    'Número de identificación tributaria', // Título de la opción
    "NIT", // Valor asociado a la opción
  ),
];
