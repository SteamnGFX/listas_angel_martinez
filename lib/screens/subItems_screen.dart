import 'package:flutter/material.dart';
import '../models/items.dart';

class SubItemListScreen extends StatefulWidget {
  final Item item;

  const SubItemListScreen({Key? key, required this.item}) : super(key: key);

  @override
  _SubItemListScreenState createState() => _SubItemListScreenState();
}

class _SubItemListScreenState extends State<SubItemListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista - ${widget.item.title}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Volver',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final SubItem item = widget.item.subItems.removeAt(oldIndex);
            widget.item.subItems.insert(newIndex, item);
          });
        },
        children: List.generate(widget.item.subItems.length, (index) {
          int itemNumber = index + 1; // Calculamos el número de item
          return Dismissible(
            key: ValueKey(widget.item.subItems[index].title),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return await _confirmarEliminarSubItem(index);
              } else if (direction == DismissDirection.startToEnd) {
                _editarSubItem(index);
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
              title: Text('$itemNumber - ${widget.item.subItems[index].title}'),
            ),
          );
        }),
      ),
      floatingActionButton: Tooltip(
        message: 'Agregar un nuevo elemento',
        child: FloatingActionButton(
          onPressed: _agregarItem,
          backgroundColor: Colors.blue[800],
          child: Icon(Icons.add, color: Colors.white), // Icono blanco
        ),
      ),
    );
  }

  Future<bool> _confirmarEliminarSubItem(int index) async {
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
                  widget.item.subItems.removeAt(index);
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

  void _agregarItem() {
    TextEditingController controller = TextEditingController();
    FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Nombre'),
          content: TextField(
            controller: controller,
            focusNode: focusNode, // Asignamos el FocusNode al TextField
            autofocus: true, // Activamos el autofocus del TextField
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
                _addSubItem(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );

    // Solicitamos el enfoque después de que se muestre el diálogo
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  void _addSubItem(String title) {
    if (title.isEmpty) return;

    setState(() {
      widget.item.subItems.add(SubItem(title: title));
    });
  }

  void _editarSubItem(int index) {
    TextEditingController controller = TextEditingController(
      text: widget.item.subItems[index].title,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar'),
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
                  widget.item.subItems[index].title = controller.text;
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
}
