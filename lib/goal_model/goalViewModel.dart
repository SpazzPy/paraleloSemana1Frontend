import 'package:paraleloapp1/data/data_repository.dart';

class GoalViewModel {
  final DataRepository repository;

  List goals = [];

  GoalViewModel(this.repository) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    goals = await repository.fetchGoals();
  }

  Future<void> addGoal(Map<String, dynamic> goalData) async {
    await repository.addGoal(goalData);
    await loadGoals();
  }

  Future<void> deleteGoal(String goalId) async {
    await repository.deleteGoal(goalId);
    await loadGoals();
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> updatedGoalData) async {
    await repository.updateGoal(goalId, updatedGoalData);
    await loadGoals();
  }
}
