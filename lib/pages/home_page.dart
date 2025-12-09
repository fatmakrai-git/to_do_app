import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'listes_des_taches.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void addTask(String task) async {
    // Lire la liste actuelle pour éviter les décalages
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList('tasks') ?? [];
    current.add(task);
    await prefs.setStringList('tasks', current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListesDesTaches()),
              );
              // Rafraîchir les tâches affichées si ListesDesTaches a été modifiée
              if (result == true) {
                loadTasks();
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('Bienvenue !')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
          if (result != null && result is String) {
            addTask(result);
          }
        },
      ),
    );
  }
}