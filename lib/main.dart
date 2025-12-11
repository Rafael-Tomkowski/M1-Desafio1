import 'package:flutter/material.dart';
import 'course_data.dart'; // Importa nosso arquivo de dados

void main() {
  runApp(const CourseFinderApp());
}

class CourseFinderApp extends StatelessWidget {
  const CourseFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Cursos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CourseSearchScreen(),
    );
  }
}

class CourseSearchScreen extends StatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  // Controlador para obter o texto do TextField
  final TextEditingController _searchController = TextEditingController();
  // Variável para armazenar o curso encontrado (pode ser nulo)
  Course? _foundCourse;

  // Função chamada ao clicar no botão de busca
  void _searchCourse() {
    // Pega o texto do controlador e usa a função de busca
    final String courseName = _searchController.text;
    final Course? result = findCourseByName(courseName);

    // Atualiza o estado da tela com o curso encontrado
    setState(() {
      _foundCourse = result;
    });

    // Limpa o campo de busca (opcional)
    _searchController.clear();
  }

  // Widget para exibir os detalhes do curso
  Widget _buildCourseDetails(Course course) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Curso Encontrado:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDetailRow('Nome:', course.name),
            _buildDetailRow('Duração:', course.duration),
            _buildDetailRow('Nível:', course.level),
            const SizedBox(height: 10),
            Text(
              'Descrição:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(course.description),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para as linhas de detalhe (Nome, Duração, etc.)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Cursos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Campo para digitar o nome do curso
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nome do Curso (ex: Desenvolvimento Web com Flutter)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
              onSubmitted: (_) => _searchCourse(), // Permite buscar ao pressionar Enter
            ),
            const SizedBox(height: 10),

            // 2. Botão de busca
            ElevatedButton.icon(
              onPressed: _searchCourse,
              icon: const Icon(Icons.search),
              label: const Text('Buscar Curso'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            
            const SizedBox(height: 20),
            const Divider(),

            // 3. Exibição dos resultados
            Expanded(
              child: SingleChildScrollView(
                child: _foundCourse == null
                    ? Center(
                        child: Text(
                          // Mensagem baseada no estado da busca
                          _searchController.text.isEmpty && _foundCourse == null
                              ? 'Digite o nome do curso para buscar.'
                              : 'Curso não encontrado. Tente um nome exato, como "Desenvolvimento Web com Flutter".',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      )
                    : _buildCourseDetails(_foundCourse!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}