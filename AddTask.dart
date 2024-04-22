import 'package:flutter/material.dart';
import 'package:sql_application/Assignment1/Dashboard.dart';
import 'package:sql_application/Assignment1/Task.dart';
import 'package:sql_application/Assignment1/Task_Service.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? priority;
  Duration? difference;
  void setpriority()
  {
    print("${_selectedDate.toLocal()}".split(' ')[0].runtimeType);
    setState(() {
      DateTime todayy = DateTime.now();
      difference = _selectedDate.difference(todayy);
    });
    if(difference!.inDays >=10)
    {
      priority = "Low";
    }
    else if(difference!.inDays >=5 && difference!.inDays <= 10)
    {
      priority = "Average";
    }
    else if(difference!.inDays >=0 && difference!.inDays <= 5)
    {
      priority = "High";
    }
    print(priority);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
     body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: descriptionController,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                   SizedBox(height: 20.0),
                  GestureDetector(
                  onTap: () {
                    _selectDate(context);
                    },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 18 , color: Colors.black),
                    ),
                    Icon(Icons.calendar_today),
                    ],
                      ),
                      ),
                      ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                          setpriority();
                          String? name_v = nameController.text.toString();
                          String? description_v = descriptionController.text.toString();

                          var taskModel = Task_Model();
                        
                          taskModel.name = name_v;
                          taskModel.description = description_v;
                          taskModel.date = "${_selectedDate.toLocal()}".split(' ')[0];
                          taskModel.priority = priority;

                          var service = Taskservice();
                          var result = await service.insertService(taskModel);
                          print(result);

                          nameController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
                          
                        
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}