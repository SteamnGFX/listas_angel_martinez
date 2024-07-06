import 'package:flutter/material.dart';
import '../models/items.dart';
import '../utils/guardar_util.dart';
import 'subItems_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
                    'Angel Martinez - Examen',
                    style: TextStyle(color: Colors.white), // Color blanco para el texto del título
                  ), 
           backgroundColor: Colors.blue[800],
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              tooltip: 'Menu desplegable',
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Utilizamos Scaffold.of() con el contexto del Builder
              },
            ),
          ),
        ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800], // Color azul oscuro
              ),
              child: const Text('Menú Lateral', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Listas de listas - Angel Martinez'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(items[index].title),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return await _confirmarEliminarItem(index);
              } else if (direction == DismissDirection.startToEnd) {
                _editarItem(index);
                return false;
              }
              return false;
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(items[index].title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubItemListScreen(item: items[index]),
                  ),
                ).then((value) {
                  _guardarDatos();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: Tooltip(
          message: 'Agregar una nueva lista',
          child: FloatingActionButton(
            onPressed: _agregarItem,
            backgroundColor: Colors.blue[800],
            child: Icon(Icons.add, color: Colors.white), // Icono blanco
          ),
        ),
    );
  }

  void _agregarItem() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nombre de Lista Nueva'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nombre'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarItems(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  void _agregarItems(String title) {
    if (title.isEmpty) return;

    setState(() {
      items.add(Item(title: title));
      _guardarDatos();
    });
  }

  Future<bool> _confirmarEliminarItem(int index) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                  _guardarDatos();
                });
                Navigator.of(context).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _editarItem(int index) {
    TextEditingController controller = TextEditingController(
      text: items[index].title,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar lista'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nuevo Nombre'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items[index].title = controller.text;
                  _guardarDatos();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _cargarDatos() async {
    items = await StorageUtil.cargarItems();
    setState(() {});
  }

  void _guardarDatos() async {
    await StorageUtil.guardarItems(items);
  }
}
