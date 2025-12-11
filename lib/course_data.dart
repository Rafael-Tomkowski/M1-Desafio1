import 'package:collection/collection.dart'; // Import necessário para firstWhereOrNull

// Modelo de dados para o curso
class Course {
  final String name;
  final String description;
  final String duration;
  final String level;

  Course({
    required this.name,
    required this.description,
    required this.duration,
    required this.level,
  });
}

// Dados de mock (simulação) dos cursos
final List<Course> mockCourses = [
  Course(
    name: 'Desenvolvimento Web com Flutter',
    description: 'Aprenda a criar aplicações web responsivas e de alto desempenho usando o Flutter.',
    duration: '120 horas',
    level: 'Intermediário',
  ),
  Course(
    name: 'Introdução à Programação em Dart',
    description: 'Fundamentos da linguagem Dart, essencial para o desenvolvimento Flutter.',
    duration: '40 horas',
    level: 'Iniciante',
  ),
  Course(
    name: 'Engenharia de Software',
    description: 'Estudo de métodos e ferramentas para o desenvolvimento e manutenção de sistemas de software.',
    duration: '200 horas',
    level: 'Avançado',
  ),
];

// Função para buscar um curso pelo nome
Course? findCourseByName(String name) {
  // Converte o nome buscado e os nomes dos cursos para minúsculas
  // para garantir que a busca não diferencie maiúsculas de minúsculas
  final searchKey = name.toLowerCase().trim();

  // Usamos firstWhereOrNull, que lida corretamente com a Null Safety,
  // retornando null se nenhum curso for encontrado.
  return mockCourses.firstWhereOrNull(
    (course) => course.name.toLowerCase() == searchKey,
  );
}