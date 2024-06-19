class TipoDocumento {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  TipoDocumento(this.titulo, this.valor);
}

final List options = [
  TipoDocumento('Tarjeta de Identidad', 'TI'),
  TipoDocumento('Cedula Ciudadanía', "CC"),
  TipoDocumento('Cedula Extranjería', "CE"),
  TipoDocumento('Pasaporte', "PAS"),
  TipoDocumento('Número de identificación tributaria', "NIT"),
];
