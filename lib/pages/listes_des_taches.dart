import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListesDesTaches extends StatefulWidget {
  const ListesDesTaches({super.key});

  @override
  State<ListesDesTaches> createState() => _ListesDesTachesState();
}

class _ListesDesTachesState extends State<ListesDesTaches> {
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedTasks = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = loadedTasks;
    });
  }

  void deleteTask(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks.removeAt(index);
    });
    await prefs.setStringList('tasks', tasks);
  }

  // Méthode publique pour permettre à HomePage de forcer le refresh
  Future<void> refresh() async {
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des tâches'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Aucune tâche pour l’instant'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                );
              },
            ),
    );
  }
}