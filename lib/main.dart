import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CrudHomePage(title: 'Simple CRUD App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Item {
  String id;
  String name;
  String description;

  Item({required this.id, required this.name, required this.description});
}

class CrudHomePage extends StatefulWidget {
  const CrudHomePage({super.key, required this.title});
  final String title;

  @override
  State<CrudHomePage> createState() => _CrudHomePageState();
}

class _CrudHomePageState extends State<CrudHomePage> {
  final List<Item> _items = [];
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Función para mostrar el formulario modal (Crear/Actualizar)
  void _showForm(String? id) {
    if (id != null) {
      // Buscar el ítem para actualizar
      final existingItem = _items.firstWhere((element) => element.id == id);
      _nameController.text = existingItem.name;
      _descriptionController.text = existingItem.description;
    } else {
      // Limpiar el formulario para crear uno nuevo
      _nameController.text = '';
      _descriptionController.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          // Esto evita que el teclado cubra los campos de texto
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validar que no estén vacíos
                if (_nameController.text.isEmpty) return;

                if (id == null) {
                  _addItem(); // CREATE
                } else {
                  _updateItem(id); // UPDATE
                }
                
                // Limpiar campos y cerrar modal
                _nameController.text = '';
                _descriptionController.text = '';
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Crear Nuevo' : 'Actualizar'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // CREATE
  void _addItem() {
    setState(() {
      _items.add(
        Item(
          id: DateTime.now().toString(),
          name: _nameController.text,
          description: _descriptionController.text,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Ítem añadido exitosamente!')),
    );
  }

  // UPDATE
  void _updateItem(String id) {
    setState(() {
      final index = _items.indexWhere((element) => element.id == id);
      if (index != -1) {
        _items[index].name = _nameController.text;
        _items[index].description = _descriptionController.text;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Ítem actualizado exitosamente!')),
    );
  }

  // DELETE
  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((element) => element.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Ítem eliminado exitosamente!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // READ (Lista de ítems)
      body: _items.isEmpty
          ? const Center(child: Text('No hay ítems todavía. ¡Añade algunos!'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => _showForm(item.id),
                          child: const Text('Editar', style: TextStyle(color: Colors.blue)),
                        ),
                        TextButton(
                          onPressed: () => _deleteItem(item.id),
                          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        tooltip: 'Añadir Ítem',
        child: const Icon(Icons.add),
      ),
    );
  }
}
