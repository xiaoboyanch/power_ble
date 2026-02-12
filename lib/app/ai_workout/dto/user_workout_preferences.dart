class UserWorkoutPreferences {
  final double weight;
  final TrainingGoal goal;
  final ExperienceLevel experience;
  final int daysPerWeek;
  final List<MuscleGroup> focusAreas;

  UserWorkoutPreferences({
    required this.weight,
    required this.goal,
    required this.experience,
    required this.daysPerWeek,
    required this.focusAreas,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'goal': goal.name,
      'experience': experience.name,
      'days_per_week': daysPerWeek,
      'focus_areas': focusAreas.map((e) => e.name).toList(),
    };
  }
}

// 枚举类型 - 确保AI获得标准化输入
enum TrainingGoal {
  muscle_gain('增肌'),
  fat_loss('减脂'),
  strength('力量提升'),
  endurance('耐力提升'),
  general_fitness('综合健康');

  final String chineseName;
  const TrainingGoal(this.chineseName);
}

enum ExperienceLevel {
  beginner('新手', '健身少于6个月'),
  intermediate('中级', '健身6个月-2年'),
  advanced('高级', '健身2年以上');

  final String chineseName;
  final String description;
  const ExperienceLevel(this.chineseName, this.description);
}

enum MuscleGroup {
  chest('胸部'),
  back('背部'),
  legs('腿部'),
  shoulders('肩部'),
  arms('手臂'),
  core('核心');

  final String chineseName;
  const MuscleGroup(this.chineseName);
}

// 训练计划模型（与之前相同但优化了工厂方法）
class WorkoutPlan {
  final List<DailyPlan> weekPlan;
  final String summary;
  final DateTime generatedAt;

  WorkoutPlan({
    required this.weekPlan,
    required this.summary,
    required this.generatedAt,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      weekPlan: (json['week_plan'] as List)
          .map((i) => DailyPlan.fromJson(i))
          .toList(),
      summary: json['summary'] ?? '',
      generatedAt: DateTime.parse(json['generated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

}

class DailyPlan {
  final String day;
  final String focus;
  final List<Exercise> exercises;

  DailyPlan({
    required this.day,
    required this.focus,
    required this.exercises,
  });

  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      day: json['day'],
      focus: json['focus'],
      exercises: (json['exercises'] as List)
          .map((i) => Exercise.fromJson(i))
          .toList(),
    );
  }
}

class Exercise {
  final String name;
  final String exerciseId;
  final int sets;
  final String reps;
  final int restSeconds;
  final String notes;

  Exercise({
    required this.name,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.notes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        name: json['name'],
      exerciseId: json['exercise_id'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['rest_seconds'] ?? 60,
      notes: json['notes'] ?? '',
    );
  }
}