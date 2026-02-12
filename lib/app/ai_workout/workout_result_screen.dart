// lib/ui/workout_result_screen.dart

import 'package:flutter/material.dart';

import 'dto/user_workout_preferences.dart';

class WorkoutResultScreen extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutResultScreen({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: plan.weekPlan.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('您的专属训练计划'),
          bottom: TabBar(
            isScrollable: true,
            tabs: plan.weekPlan.map((day) => Tab(text: day.day)).toList(),
          ),
        ),
        body: TabBarView(
          children: plan.weekPlan.map((dailyPlan) {
            return _buildDayPlan(dailyPlan);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDayPlan(DailyPlan dailyPlan) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dailyPlan.focus,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('${dailyPlan.exercises.length}个动作 · ${_calculateTotalSets(dailyPlan)}组'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        ...dailyPlan.exercises.map((exercise) => _buildExerciseCard(exercise)).toList(),
      ],
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(exercise.sets.toString()),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: ${exercise.exerciseId}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip('${exercise.sets}组', Icons.repeat),
                _buildInfoChip(exercise.reps, Icons.format_list_numbered),
                _buildInfoChip('${exercise.restSeconds}秒休息', Icons.timer),
              ],
            ),
            if (exercise.notes.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                '💡 ${exercise.notes}',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: Colors.grey[100],
    );
  }

  int _calculateTotalSets(DailyPlan dailyPlan) {
    return dailyPlan.exercises.fold(0, (total, exercise) => total + exercise.sets);
  }
}