import 'package:flutter/material.dart';
import 'package:paraleloapp1/login_module/login_screen.dart';
import 'goalViewModel.dart';
import 'package:paraleloapp1/data/data_repository.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final GoalViewModel viewModel = GoalViewModel(DataRepository());

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    await viewModel.loadGoals();
    setState(() {}); // Refresh UI after goals are loaded
  }

  void _addNewGoal() async {
    // Logic to input and add a new goal
    Map<String, dynamic> newGoal = await _inputDialog(context);
    if (newGoal.isNotEmpty) {
      await viewModel.addGoal(newGoal);
      _loadGoals(); // Reload goals and refresh UI
    }
  }

  Future<Map<String, dynamic>> _editGoalDialog(BuildContext context, Map<String, dynamic> existingGoal) async {
    TextEditingController goalFieldController = TextEditingController(text: existingGoal['goal_name']);
    TextEditingController goalAmountFieldController = TextEditingController(text: existingGoal['goal_amount'].toString());
    TextEditingController interestRateFieldController = TextEditingController(text: existingGoal['interest_rate'].toString());
    TextEditingController timeDurationFieldController = TextEditingController(text: existingGoal['time_duration'].toString());

    Map<String, dynamic> goalData = {};
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Goal Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: goalFieldController,
                  decoration: InputDecoration(
                    labelText: "Goal Name",
                    hintText: "Goal Name",
                  ),
                ),
                TextField(
                  controller: goalAmountFieldController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: interestRateFieldController,
                  decoration: InputDecoration(
                    labelText: "Interest Rate",
                    hintText: "Interest Rate",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: timeDurationFieldController,
                  decoration: InputDecoration(
                    labelText: "Duration (Years)",
                    hintText: "Duration (Years)",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FloatingActionButton(
              child: Text('OK'),
              onPressed: () {
                goalData = {
                  "goal_name": goalFieldController.text,
                  "goal_amount": goalAmountFieldController.text,
                  "interest_rate": interestRateFieldController.text,
                  "time_duration": timeDurationFieldController.text,
                };
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    return goalData;
  }

  void _editGoal(Map<String, dynamic> existingGoal) async {
    Map<String, dynamic> updatedGoal = await _editGoalDialog(context, existingGoal);
    if (updatedGoal.isNotEmpty) {
      await viewModel.updateGoal(existingGoal['id'], updatedGoal); // Assuming you have a method to update the goal
      _loadGoals();
    }
  }

  Future<Map<String, dynamic>> _inputDialog(BuildContext context) async {
    TextEditingController goalFieldController = TextEditingController();
    TextEditingController goalAmountFieldController = TextEditingController();
    TextEditingController interestRateFieldController = TextEditingController();
    TextEditingController timeDurationFieldController = TextEditingController();

    Map<String, dynamic> goalData = {};
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Goal Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: goalFieldController,
                  decoration: InputDecoration(hintText: "Goal Name"),
                ),
                TextField(
                  controller: goalAmountFieldController,
                  decoration: InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: interestRateFieldController,
                  decoration: InputDecoration(hintText: "Interest Rate"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: timeDurationFieldController,
                  decoration: InputDecoration(hintText: "Duration (Years)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FloatingActionButton(
              child: Text('OK'),
              onPressed: () {
                goalData = {"goal_name": goalFieldController.text, "goal_amount": goalAmountFieldController.text, "interest_rate": interestRateFieldController.text, "time_duration": timeDurationFieldController.text};
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    return goalData;
  }

  void _deleteGoal(String goalId) async {
    await viewModel.deleteGoal(goalId);
    _loadGoals(); // Reload goals and refresh UI
  }

  void _logout() {
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Investment Goals"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: viewModel.goals.length,
        itemBuilder: (context, index) {
          var goal = viewModel.goals[index];
          return InkWell(
            onTap: () => _editGoal(goal),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Goal: ${goal['goal_name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Amount: ${goal['goal_amount']}"),
                    Text("Interest Rate: ${goal['interest_rate']}%"),
                    Text("Duration: ${goal['time_duration']} years"),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteGoal(goal['id']),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGoal,
        child: Icon(Icons.add),
      ),
    );
  }
}
