
import 'package:flutter/material.dart';
import 'package:to_do_app/homepage.dart';

class TaskDetailPage extends StatefulWidget {
  final Note note;

  const TaskDetailPage({required this.note});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
final _taskaddController = TextEditingController();
late TextEditingController _taskTitleController = TextEditingController();

late List<Task> tasks;
late String initText;
FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tasks = List.from(widget.note.tasks);
    _taskTitleController = TextEditingController(text: widget.note.title);
  }

@override
void dispose(){
  _taskTitleController.dispose();
  super.dispose();
}
void _autosavetask(){
Navigator.pop(context, Note(
  title: _taskTitleController.text,
  tasks: tasks));
  if (_taskaddController.text.isNotEmpty){
    setState(() {
      tasks.add(Task(description: _taskaddController.text));
    });
  }
}
void _deleteNote(){
  Navigator.pop(context, null);
}
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        _autosavetask();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 242, 255),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5780FF),
          leading: IconButton(
            onPressed: () {
              _autosavetask();
              },
          icon: const Icon(Icons.arrow_back, color: Colors.white,)),
          title: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none
            ),
              controller: _taskTitleController,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (Colors.white)),
                onChanged: (value) {
                  setState(() {
                    
                  });
                },
          ),
          actions: [
            IconButton(onPressed: (){
              _deleteNote();
            },
            icon: const Icon(Icons.delete, color: Colors.white,))
          ],
        ),
        body: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              style: TextStyle(
                fontSize: 18,
              ),
              controller: _taskaddController,
              decoration: const InputDecoration(
                // border: InputBorder.none,
                icon:Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(Icons.fiber_manual_record_sharp, size: 14,),
                    ),
                  ],
                ) ,
                labelText: 'Add a new task',
              ),
              focusNode: myFocusNode,
              onSubmitted: (value) {
                  setState(() {
                    tasks.add(Task(description: value));
                    _taskaddController.clear();
                    myFocusNode.requestFocus();
                  });
                }
            ),
                      ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: tasks[index].isCompleted,
                            title: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              controller: TextEditingController(text: tasks[index].description),
                              onSubmitted: (newValue){
                                setState(() {
                                  tasks[index].description = newValue;
                                });
                              },
                            style: TextStyle(
                              fontSize: 18,
                              decoration: tasks[index].isCompleted? TextDecoration.lineThrough: TextDecoration.none
                              ),
                              ),
                            onChanged: (bool? value) {
                              setState(() {
                                tasks[index].isCompleted = value!;
                              });
                            },
                            // checkColor: Colors.orange,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              tasks.removeAt(index);
                            });
                          }
                        , icon: const Icon(Icons.close))
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}