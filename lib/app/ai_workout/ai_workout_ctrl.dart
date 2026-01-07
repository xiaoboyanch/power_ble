import 'package:cabina_ble/app/ai_workout/workout_result_screen.dart';
import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../ai/deepseek_service.dart';
import 'dto/user_workout_preferences.dart';

class AIWorkoutCtrl extends GetxController {

  RxInt flag = 0.obs;

  // 表单数据
  double weight = 70.0;
  TrainingGoal selectedGoal = TrainingGoal.muscle_gain;
  ExperienceLevel selectedLevel = ExperienceLevel.intermediate;
  int selectedDays = 4;
  final List<MuscleGroup> selectedAreas = [MuscleGroup.chest, MuscleGroup.back];
  late DeepSeekService deepSeekService;

  bool isGenerating = false;
  WorkoutPlan? generatedPlan;

  @override
  void onInit() {
    super.onInit();
    String key = dotenv.get('DEEPSEEK_API_KEY');
    deepSeekService = DeepSeekService(key);
  }

  void generatePlan() async {
    isGenerating = true;
    flag.value++;
    try {
      final preferences = UserWorkoutPreferences(
        weight: weight,
        goal: selectedGoal,
        experience: selectedLevel,
        daysPerWeek: selectedDays,
        focusAreas: selectedAreas,
      );

      final plan = await deepSeekService.generateWorkoutPlan(
        preferences: preferences,
      );

      // setState(() {
        generatedPlan = plan;
        isGenerating = false;
        flag.value++;
      // });

      // 导航到结果页面
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => WorkoutResultScreen(plan: plan),
        ),
      );

    } catch (e) {
      isGenerating = false;
      flag.value++;
      RHToast.showToast(msg: '生成失败');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('生成失败: $e')),
      // );
    }
  }
}