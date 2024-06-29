class TipoDocumentoEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  TipoDocumentoEditar(this.titulo, this.valor);
}

final List options1 = [
  TipoDocumentoEditar('Tarjeta de Identidad', 'TI'),
  TipoDocumentoEditar('Cedula Ciudadanía', "CC"),
  TipoDocumentoEditar('Cedula Extranjería', "CE"),
  TipoDocumentoEditar('Pasaporte', "PAS"),
  TipoDocumentoEditar('Número de identificación tributaria', "NIT"),
];

class RolPrimerNivelEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  RolPrimerNivelEditar(this.titulo, this.valor);
}

final List rolN1 = [
  RolPrimerNivelEditar("APRENDIZ", 'APRENDIZ'),
  RolPrimerNivelEditar("INSTRUCTOR", 'INSTRUCTOR'),
  RolPrimerNivelEditar("FUNCIONARIO", 'FUNCIONARIO'),
];

class RolSegundoNivelEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  RolSegundoNivelEditar(this.titulo, this.valor);
}

final List rolN2 = [
  RolSegundoNivelEditar("TUTOR UNIDAD", 'TUTOR'),
  RolSegundoNivelEditar("PUNTO VENTA", "PUNTO"),
  RolSegundoNivelEditar("LIDER SENA", 'LIDER'),
];

class UnidadEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  UnidadEditar(this.titulo, this.valor);
}

final List unidadL = [
  RolSegundoNivelEditar("LACTEOS", 'LACTEOS'),
  RolSegundoNivelEditar("CARNICOS", "CARNICOS"),
  RolSegundoNivelEditar("HORTALIZAS", 'HORTALIZAS'),
];

class PuntoEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  PuntoEditar(this.titulo, this.valor);
}

final List puntoL = [
  PuntoEditar("PORTERÍA CBA", 'PORTERÍA CBA'),
  PuntoEditar("COLISEO CBA", "COLISEO CBA"),
  PuntoEditar("CAFETERÍA CBA", 'CAFETERÍA CBA'),
];

class SedeEditar {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  SedeEditar(this.titulo, this.valor);
}

final List sedeL = [
  PuntoEditar("Centro de Biotecnología Agropecuaría", 'Centro de Biotecnología Agropecuaría'),
  PuntoEditar("Centro de Desarrollo Agroempresarial", "Centro de Desarrollo Agroempresarial"),
];