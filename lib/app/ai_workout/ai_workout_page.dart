import 'package:cabina_ble/app/ai_workout/ai_workout_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'dto/user_workout_preferences.dart';

class AIWorkoutPage extends GetView<AIWorkoutCtrl> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Workout'),
      ),
      body: Obx(() {
        int value = controller.flag.value;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 体重输入
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '体重 (公斤)',
                      suffixText: 'kg',
                    ),
                    initialValue: controller.weight.toString(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return '请输入有效体重';
                      }
                      return null;
                    },
                    onSaved: (value) => controller.weight = double.parse(value!),
                  ),
                  SizedBox(height: 20),

                  // 训练目标选择
                  Text('训练目标', style: Theme.of(context).textTheme.titleMedium),
                  ...TrainingGoal.values.map((goal) {
                    return RadioListTile<TrainingGoal>(
                      title: Text(goal.chineseName),
                      value: goal,
                      groupValue: controller.selectedGoal,
                      onChanged: (value) {
                        controller.selectedGoal = value!;
                        controller.flag.value++;
                      });
                  }).toList(),

                  // 经验水平选择
                  Text('训练经验', style: Theme.of(context).textTheme.titleMedium),
                  ...ExperienceLevel.values.map((level) {
                    return RadioListTile<ExperienceLevel>(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(level.chineseName),
                          Text(level.description, style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      value: level,
                      groupValue: controller.selectedLevel,
                      onChanged: (value)  {
                        controller.selectedLevel = value!;
                        controller.flag.value++;
                      }
                    );
                  }).toList(),

                  // 每周天数选择
                  Text('每周训练天数', style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    children: [3, 4, 5, 6].map((days) {
                      return FilterChip(
                        label: Text('$days 天'),
                        selected: controller.selectedDays == days,
                        onSelected: (selected) {
                          controller.selectedDays = days;
                          controller.flag.value++;
                        }
                      );
                    }).toList(),
                  ),
                  // 重点部位多选
                  Text('重点训练部位', style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: MuscleGroup.values.map((area) {
                      return FilterChip(
                        label: Text(area.chineseName),
                        selected: controller.selectedAreas.contains(area),
                        onSelected: (selected) {
                            if (selected) {
                              controller.selectedAreas.add(area);
                            } else {
                              controller.selectedAreas.remove(area);
                            }
                            controller.flag.value++;
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),

                  // 生成按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.isGenerating ? null : controller.generatePlan,
                      icon: controller.isGenerating
                          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(Icons.fitness_center),
                      label: Text(controller.isGenerating ? 'AI生成中...' : '生成训练计划'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              )
          ),
        );
      }),
    );
  }

}