import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Necessário para converter Lista para String JSON

// =========================================================================
// MODELO (Classe Produto)
// =========================================================================
class Produto {
  final String nome;
  final int estoque;
  final double preco;
  final bool disponivel;

  Produto({
    required this.nome,
    required this.estoque,
    required this.preco,
    required this.disponivel,
  });

  // Método para converter o objeto Produto em um Map (JSON)
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'estoque': estoque,
        'preco': preco,
        'disponivel': disponivel,
      };

  // Construtor de fábrica para criar um Produto a partir de um Map (JSON)
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nome: json['nome'] as String,
      estoque: json['estoque'] as int,
      preco: json['preco'] as double,
      disponivel: json['disponivel'] as bool,
    );
  }
}

// =========================================================================
// WIDGET PRINCIPAL (StatefulWidget)
// =========================================================================
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Produto> listaProdutos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Carrega os produtos do armazenamento local (LocalStorage no Web)
  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString('produtos_key');

    if (productsString != null) {
      final List<dynamic> jsonList = jsonDecode(productsString);
      setState(() {
        listaProdutos = jsonList.map((json) => Produto.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      // Se não houver dados salvos, usa dados iniciais (MOCK)
      _useInitialData();
    }
  }
  
  // Dados iniciais (MOCK) - **CORREÇÃO: removido o 'const' aqui.**
  void _useInitialData() {
    listaProdutos = [ 
      Produto(nome: "Notebook Pro X1", estoque: 42, preco: 3999.90, disponivel: true),
      Produto(nome: "Mouse Gamer RGB", estoque: 150, preco: 129.90, disponivel: true),
      Produto(nome: "Teclado Mecânico", estoque: 0, preco: 450.00, disponivel: false),
    ];
    _saveProducts(); // Salva os dados iniciais
    setState(() {
      isLoading = false;
    });
  }

  // Salva a lista de produtos no armazenamento local
  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = listaProdutos.map((produto) => produto.toJson()).toList();
    final productsString = jsonEncode(jsonList);
    await prefs.setString('produtos_key', productsString);
  }

  // Constrói o widget de Card para um único produto
  Widget _buildProductCard(Produto produto) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Divider(height: 15, thickness: 1),
            _buildInfoRow('Estoque:', '${produto.estoque} unidades'),
            _buildInfoRow('Preço:', 'R\$ ${produto.preco.toStringAsFixed(2)}'),
            _buildInfoRow(
              'Status:',
              produto.disponivel ? 'Disponível' : 'Indisponível',
              color: produto.disponivel ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para as linhas de informação
  Widget _buildInfoRow(String label, String value, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos (Persistente)'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: listaProdutos.length,
              itemBuilder: (context, index) {
                final produto = listaProdutos[index];
                return _buildProductCard(produto);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adiciona um novo produto de exemplo e salva
          setState(() {
            listaProdutos.add(
              Produto(nome: 'Novo Item Salvo ${listaProdutos.length}', estoque: 1, preco: 1.00, disponivel: true),
            );
          });
          _saveProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Novo produto adicionado e salvo localmente!')),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

// =========================================================================
// ARRANQUE DA APLICAÇÃO
// =========================================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalhes do Produto',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const ProductDetailPage(),
    );
  }
}