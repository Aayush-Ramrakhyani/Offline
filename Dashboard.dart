import 'package:flutter/material.dart';
import 'package:sql_application/Assignment1/AddTask.dart';
import 'package:sql_application/Assignment1/EditTask.dart';
import 'package:sql_application/Assignment1/Task.dart';
import 'package:sql_application/Assignment1/Task_Service.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
 List<Task_Model> task_list = [];
  var taskservice = Taskservice();
  var taskModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRecordFromDB();
  }

  getRecordFromDB() async {
    var allTask = await taskservice.getservice();

    allTask.forEach((task) {
      print("-----------------> ${task["id"]}");
      taskModel = Task_Model();
        taskModel.id = task["id"];
        taskModel.name = task["name"];
        taskModel.description = task["description"];
        taskModel.date = task["date"];
        taskModel.priority = task["priority"];

      setState(() {
        task_list.add(taskModel);
      });
      print(task_list);
    });
  }
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management"),
      ),
      body: ListView.builder(
        itemCount: task_list.length,
        itemBuilder: (context, index) {
          return Container(
            child: GestureDetector(
              onDoubleTap: () async {
                await taskservice
                              .deleteservice(task_list[index].id);

                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashBoardScreen(),
                              ));
              },
              onTap: () {
                Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskScreen(task_model: task_list[index],id: task_list[index].id,),
                              ));
              },
              child: Card(
                color: task_list[index].priority == "Low" ?  Colors.green : task_list[index].priority == "Average" ? Colors.blue : task_list[index].priority == "High" ?  Colors.red : Colors.grey,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text("Title ${task_list[index].name}"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Descriptiopn: ${task_list[index].description}"),
                      
                      Text("Date: ${task_list[index].date}"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNewTask(),));
      },
      child: Icon(Icons.add),
      ),
    );
  }
}