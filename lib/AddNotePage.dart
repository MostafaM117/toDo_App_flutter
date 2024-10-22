import 'package:flutter/material.dart';
import 'package:to_do_app/homepage.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  final _titleController = TextEditingController();
  final _taskController = TextEditingController();
  List<Task> tasks = [];
  String? _errorText;
  
  FocusNode myFocusNode = FocusNode();
  @override
  void dispose(){
    _titleController.dispose();
    _taskController.dispose();
    super.dispose();
  }
  
  void _autosave(){
    if (_titleController.text.isEmpty && _taskController.text.isEmpty){
      Navigator.pop(context);
    }
    else if (_titleController.text.isNotEmpty && _taskController.text.isNotEmpty){
      Navigator.pop(context, Note(
        title: _titleController.text,
        tasks: tasks));
      setState(() {
          tasks.add(Task(description: _taskController.text));
            });
    }
    else if (_titleController.text.isEmpty && _taskController.text.isNotEmpty){
      Navigator.pop(context, Note(
        title: _titleController.text,
        tasks: tasks));
      setState(() {
        tasks.add(Task(description: _taskController.text));
      });
      }
    else if (_titleController.text.isNotEmpty && _taskController.text.isEmpty){
      Navigator.pop(context, Note(
      title: _titleController.text,
      tasks: tasks));
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop){
        if(didPop){
          return;
        }
        _autosave();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 242, 255),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5780FF),
          leading: IconButton(
            onPressed: (){
              _autosave();
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,)),
          title: const Text(
            "Create a note",
            style:TextStyle(fontWeight: FontWeight.bold, color: (Colors.white)) ,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                decoration: 
                InputDecoration(
                  contentPadding: const EdgeInsets.only(
                        left: 8.0, top: 2.0,
                        ),
                  labelText: 'Note title',
                  errorText: _errorText,
                ),
                textInputAction: TextInputAction.next,
              ),              
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: TextField(
                    controller: _taskController,
                    focusNode: myFocusNode,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 8.0, top: 2.0,
                        ),
                      // border: OutlineInputBorder(),
                      icon:Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(Icons.fiber_manual_record_sharp, size: 14,),
                          ),
                        ],
                      ),
                      labelText: 'Add a new Task',
                    ),
                    onSubmitted: (value) {
                if(value.isNotEmpty){
                  setState(() {
                    tasks.add(Task(description: value));
                    _taskController.clear();
                    myFocusNode.requestFocus();
                  });
              }
                }
                  ),
                  ),
                  const SizedBox(
                  width: 15,
                  // height: 10,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10
                  ),
                  child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: TextField(
                              controller: TextEditingController(text: tasks[index].description),
                              decoration: InputDecoration(
                                border: InputBorder.none
                              ),
                              onSubmitted: (newValue) {
                                if(newValue.isNotEmpty){
                                    setState(() {
                                        tasks[index].description = newValue;
                                      });
                                }
                                    },
                                    style: TextStyle(
                                    fontSize: 18,
                                    decoration: tasks[index].isCompleted? TextDecoration.lineThrough: TextDecoration.none
                                    ),
                            ),
                            value: tasks[index].isCompleted,
                            onChanged: (bool? value){
                              setState(() {
                                tasks[index].isCompleted = value!;
                              });
                            },
                          ),
                        ),IconButton(
                          onPressed: (){
                            setState(() {
                              tasks.removeAt(index);
                            });
                          }
                        , icon: const Icon(Icons.close))
                      ],
                    );
                  }),
                )),
            ],
          ),
        ),
      ),
    );
  }
}