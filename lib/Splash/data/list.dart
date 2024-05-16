import 'package:tienda_app/constantsDesign.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Clase que define los componentes utilizados en la pantalla de bienvenida
class Components {
  String titulo; // Título del componente
  String descripcion; // Descripción del componente
  Widget
      backgroundColor; // Fondo del componente (puede ser un widget como Lottie)
  String imagen2; // Segunda imagen relacionada al componente
  Color background; // Color de fondo del componente

  // Constructor que inicializa los atributos de la clase
  Components(
      {
      required this.titulo,
      required this.descripcion,
      required this.backgroundColor,
      required this.imagen2,
      required this.background});
}

// Lista que contiene instancias de la clase Components, representando cada componente de la pantalla
List<Components> listaComponents = [
  Components(
      titulo: "Formación Profesional Integral",
      descripcion: "El Servicio Nacional de Aprendizaje (SENA) ofrece una formación que abarca conocimientos teóricos y prácticos en diversos campos, permitiendo a los estudiantes desarrollar habilidades sólidas para desempeñarse en el mercado laboral.",
      backgroundColor: LottieBuilder.asset(
        "assets/animation/animation3.json",
        fit: BoxFit.cover,
      ),
      imagen2: 'assets/splash1.jpg',
      background: primaryColor),
  Components(
      titulo: "Acceso a Tecnología y Equipamiento de Vanguardia",
      descripcion: "Gracias a la infraestructura y recursos del SENA, los estudiantes tienen acceso a tecnología de última generación y equipamiento especializado en sus áreas de estudio, lo que les permite aprender utilizando herramientas y métodos actualizados.",
      backgroundColor: Padding(
        padding: const EdgeInsets.only(top: 180),
        child: LottieBuilder.asset(
          "assets/animation/animation3.json",
          fit: BoxFit.cover,
        ),
      ),
      imagen2: 'assets/splash2.jpg',
      background: Colors.white),
  Components(
      titulo: "Conexiones con el Mundo Laboral",
      descripcion: "El SENA establece vínculos estrechos con empresas e industrias, lo que facilita oportunidades de prácticas profesionales y pasantías para los estudiantes. Esto les brinda una experiencia real en el campo laboral y les ayuda a establecer contactos que pueden ser útiles para su futuro empleo.",
      backgroundColor: LottieBuilder.asset("assets/animation/animation3.json",
          fit: BoxFit.cover),
      imagen2: 'assets/splash3.jpg',
      background: primaryColor),
  Components(
      titulo: "Programas Flexibles y Adaptados a las Necesidades del Estudiante",
      descripcion: "El SENA ofrece una amplia gama de programas de formación que se adaptan a diferentes niveles de educación y horarios. Esto permite a las personas estudiar mientras trabajan o realizan otras actividades, lo que facilita su acceso a la educación.",
      backgroundColor: Padding(
        padding: const EdgeInsets.only(top: 180),
        child: LottieBuilder.asset(
          "assets/animation/animation3.json",
          fit: BoxFit.cover,
        ),
      ),
      imagen2: 'assets/splash4.jpg',
      background: Colors.white),
  Components(
      titulo: "Certificación Reconocida y Valorada",
      descripcion: "Los títulos y certificados otorgados por el SENA son reconocidos a nivel nacional e incluso internacional, lo que aumenta las oportunidades de empleo para los graduados y les permite competir en el mercado laboral con mayor éxito.",
      backgroundColor: LottieBuilder.asset("assets/animation/animation3.json",
          fit: BoxFit.cover),
      imagen2: 'assets/splash5.jpg',
      background: primaryColor),
];
