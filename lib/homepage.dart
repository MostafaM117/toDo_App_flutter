import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:to_do_app/AddNotePage.dart';
import 'package:to_do_app/TaskDetailPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
List<Note> notes = [];

showAlert(BuildContext context, int index){
  Widget cancelbutton = TextButton(
    onPressed: (){
      Navigator.of(context).pop();
    }, child: const Text("Cancel"));

  Widget confirmbutton = TextButton(
    onPressed: (){
      setState(() {
        notes.removeAt(index);
              Navigator.of(context).pop();
      });
    }, child: const Text("Yes"));
  
  AlertDialog alert = AlertDialog(
    title: const Text("Confirming Delete",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold),),
    content: const Text("Are you sure that you want to delete this note? \n This action can't be undone!",),
    actions: [
      cancelbutton,
      confirmbutton
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context){
      return alert;
    });
}


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 253, 248, 203),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5780FF),
          title: const Center(child: Text("To Do App",
            style: TextStyle(fontWeight:FontWeight.bold),)
          ),
          foregroundColor: Colors.white,
        ),
        body: notes.isEmpty
          ? const Center(
              child: Text(
                'No notes to be displayed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          :Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index){
            double progress = notes[index].calculateProgress();
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  // tileColor: Colors.white,
                  leading: CircularPercentIndicator(
                    radius: 28.0,
                    percent: progress,
                    center: Text("${(progress*100).toInt()}%"),
                    progressColor: const Color(0xFF5780FF),
                    ),
                  title: Text(notes[index].title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold) ,),
                  subtitle: Text("${notes[index].tasks.length} tasks"),
                  onTap: () async{
                    final updatedNote = await Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => TaskDetailPage(note: notes[index]),
                      ),
                      );
                      if (updatedNote != null){
                        setState(() {
                          notes[index] = updatedNote;
                        });
                      }
                      else if(updatedNote == null){
                        setState(() {
                          notes.removeAt(index);
                        });
                      }
                  },
                  trailing: IconButton(onPressed: (){
                    showAlert(context, index);
                  }, icon: const Icon(Icons.delete)),
                ),
              ),
            );
            }
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 15),
            child: FloatingActionButton(
              backgroundColor: Color(0xFF5780FF),
              onPressed: () async {
                final Note? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNotePage()),
                  );
                  if (result != null){
                    setState(() {
                      notes.add(result);
                    });
                  }
              },
              child: const Icon(Icons.add, color: Color(0xFFFFFFFF),),
              ),
          )
    );
  }
}

class Note {
  String title;
  List<Task> tasks;
  Note({
    required this.title,
    required this.tasks,
  });
double calculateProgress() {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }
}
class Task {
  String description;
  bool isCompleted;
  Task({required this.description, this.isCompleted = false});
}