import 'dart:convert';

import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:http/http.dart' as http;

import '../ai_workout/dto/user_workout_preferences.dart';

class DeepSeekService {
  static const String _baseUrl = "https://api.deepseek.com";
  final String _apiKey;

  DeepSeekService(this._apiKey);

  Future<String> chatCompletion({
    required String message,
    String model = 'deepseek-chat',
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          // user: 表示用户输入的消息，通常是用户的提问或请求
          // assistant: 表示 AI 助手的回复，用于多轮对话的上下文
          // system: 系统提示消息，用于设定助手的行为准则或上下文背景
          // 'messages': [
          //   {'role': 'system', 'content': '你是一个有用的助手'},
          //   {'role': 'user', 'content': '你好'},
          //   {'role': 'assistant', 'content': '你好！有什么可以帮助你的吗？'},
          //   {'role': 'user', 'content': '今天天气怎么样？'}
          // ]
          'messages': [
            {'role': 'user', 'content': message}
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        LogUtils.d("返回的规格： ${response.body}");
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API请求失败: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('网络请求错误: $e');
    }
  }

  // 流式响应版本（如果需要）
  Stream<String> streamChatCompletion({
    required String message,
    String model = 'deepseek-chat',
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async* {
    try {
      final request = http.Request(
        'POST',
        Uri.parse('$_baseUrl/chat/completions'),
      )
        ..headers.addAll({
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': message}
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
          'stream': true,
        });

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        await for (var chunk in streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
          if (chunk.startsWith('data: ')) {
            final data = chunk.substring(6);
            if (data == '[DONE]') break;
            try {
              final jsonData = jsonDecode(data);
              final content = jsonData['choices'][0]['delta']['content'];
              if (content != null) {
                yield content;
              }
            } catch (_) {}
          }
        }
      } else {
        throw Exception('API请求失败: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('网络请求错误: $e');
    }
  }

  // 根据用户选择生成训练计划
  Future<WorkoutPlan> generateWorkoutPlan({
    required UserWorkoutPreferences preferences,
  }) async {
    try {
      // 1. 构建智能提示词
      String prompt = _buildWorkoutPrompt(preferences);

      // 2. 调用DeepSeek API
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一名专业的龙门架训练专家。请根据用户信息生成科学、安全、有效的训练计划。'
            },
            {'role': 'user', 'content': prompt}
          ],
          'response_format': {'type': 'json_object'},
          'max_tokens': 3000,
          'temperature': 0.7, // 降低随机性，确保计划稳定性
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];

        // 3. 解析JSON响应
        Map<String, dynamic> planJson = jsonDecode(content);

        // 4. 添加元数据
        planJson['summary'] = _generateSummary(preferences);
        planJson['generated_at'] = DateTime.now().toIso8601String();

        return WorkoutPlan.fromJson(planJson);
      } else {
        throw Exception('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('生成训练计划失败: $e');
    }
  }


  // 构建智能提示词的核心方法
  String _buildWorkoutPrompt(UserWorkoutPreferences prefs) {
    // 将动作库格式化为字符串
    String exerciseList = _cableMachineExercises.entries
        .map((e) => '${e.value} (${e.key})')
        .join('\n');

    // 构建训练重点描述
    String focusAreasStr = prefs.focusAreas
        .map((area) => area.chineseName)
        .join('、');

    // 根据目标调整训练参数
    Map<String, dynamic> goalParams = _getGoalParameters(prefs.goal);

    return '''
# 角色设定
你是一名龙门架训练专家，擅长使用绳索和滑轮系统设计高效训练方案。

# 用户信息
1. 体重：${prefs.weight}公斤
2. 训练目标：${prefs.goal.chineseName}
3. 训练经验：${prefs.experience.chineseName}（${prefs.experience.description}）
4. 每周训练天数：${prefs.daysPerWeek}天
5. 重点训练部位：${focusAreasStr}

# 训练参数要求（基于${prefs.goal.chineseName}目标）
- 每组次数范围：${goalParams['reps_range']}
- 组间休息：${goalParams['rest_time']}秒
- 训练节奏：${goalParams['tempo']}
- 每周总训练量：${goalParams['volume']}

# 可用动作库（龙门架专用）
请仅从以下动作中选择，不要创造新动作：
$exerciseList

# 训练计划编排原则
1. 每周${prefs.daysPerWeek}天训练，合理安排休息日
2. 优先编排用户指定的重点部位：${focusAreasStr}
3. 根据${prefs.experience.chineseName}水平调整动作难度
4. 复合动作优先，孤立动作为辅
5. 避免连续两天训练相同肌群
6. 每次训练包含3-5个动作

# 输出格式要求
请严格按照以下JSON格式生成一周训练计划：
{
  "week_plan": [
    {
      "day": "Monday",
      "focus": "胸部与肱三头肌",
      "exercises": [
        {
          "name": "绳索夹胸",
          "exercise_id": "ex_101",
          "sets": 4,
          "reps": "10-12",
          "rest_seconds": 60,
          "notes": "保持手肘微屈，感受胸部挤压"
        }
      ]
    }
  ]
}

# 特别指令
1. 训练日名称用英文：Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
2. exercise_id必须来自上面的动作库
3. 根据训练目标调整组数、次数和休息时间
4. 为每个动作添加简短的技术提示
5. 不要添加任何额外文字，只输出JSON
''';
  }

  // 根据训练目标获取参数
  Map<String, dynamic> _getGoalParameters(TrainingGoal goal) {
    switch (goal) {
      case TrainingGoal.muscle_gain:
        return {
          'reps_range': '8-12次',
          'rest_time': '60-90',
          'tempo': '慢速离心，快速向心',
          'volume': '中高容量',
        };
      case TrainingGoal.fat_loss:
        return {
          'reps_range': '12-15次',
          'rest_time': '30-45',
          'tempo': '中等节奏，控制间歇',
          'volume': '高容量，短间歇',
        };
      case TrainingGoal.strength:
        return {
          'reps_range': '4-6次',
          'rest_time': '120-180',
          'tempo': '爆发性向心，控制离心',
          'volume': '高强度，低次数',
        };
      case TrainingGoal.endurance:
        return {
          'reps_range': '15-20次',
          'rest_time': '30',
          'tempo': '匀速持续',
          'volume': '超高容量',
        };
      default:
        return {
          'reps_range': '10-12次',
          'rest_time': '60',
          'tempo': '标准节奏',
          'volume': '中等容量',
        };
    }
  }

  // 生成计划摘要
  String _generateSummary(UserWorkoutPreferences prefs) {
    return '${prefs.goal.chineseName}计划 · ${prefs.daysPerWeek}天/周 · 重点：${prefs.focusAreas.map((e) => e.chineseName).join('、')}';
  }

// 您的龙门架动作数据库
  static const Map<String, String> _cableMachineExercises = {
    'ex_101': '绳索夹胸',
    'ex_102': '站姿高位下拉',
    'ex_103': '单臂绳索划船',
    'ex_104': '绳索面拉',
    'ex_105': '直臂下压',
    'ex_106': '绳索弯举',
    'ex_107': '绳索肱三头肌伸展',
    'ex_108': '站姿绳索卷腹',
    'ex_109': '绳索深蹲',
    'ex_110': '绳索腿弯举',
    'ex_111': '绳索侧平举',
    'ex_112': '绳索前平举',
    'ex_113': '绳索旋转伐木',
    'ex_114': '跪姿绳索卷腹',
    'ex_115': '绳索臀冲',
    'ex_116': '绳索推胸',
    'ex_117': '绳索反向飞鸟',
    'ex_118': '绳索反手下拉',
    'ex_119': '绳索锤式弯举',
    'ex_120': '绳索颈后臂屈伸',
    'ex_121': '绳索侧屈',
    'ex_122': '绳索俄罗斯转体',
    'ex_123': '绳索平板支撑划船',
    'ex_124': '绳索山地攀爬者',
    'ex_125': '绳索腿举',
    'ex_126': '绳索髋外展',
    'ex_127': '绳索髋内收',
    'ex_128': '绳索小腿提踵',
    'ex_129': '绳索弓步蹲',
    'ex_130': '绳索木伐工',
    'ex_131': '绳索T型划船',
    'ex_132': '绳索单腿硬拉',
    'ex_133': '绳索过头推举',
    'ex_134': '绳索反向推胸',
    'ex_135': '绳索侧平举',
    'ex_136': '绳索前平举',
    'ex_137': '绳索后平举',
    'ex_138': '绳索肩部推举',
    'ex_139': '绳索肩胛骨收缩',
    'ex_140': '绳索肩部环绕',
    'ex_141': '绳索上斜夹胸',
    'ex_142': '绳索下斜夹胸',
    'ex_143': '绳索交叉飞鸟',
    'ex_144': '绳索上斜飞鸟',
    'ex_145': '绳索下斜飞鸟',
    'ex_146': '绳索俯身夹胸',
    'ex_147': '绳索坐姿划船',
    'ex_148': '绳索反向划船',
    'ex_149': '绳索直臂下拉',
    'ex_150': '绳索反向飞鸟',
    'ex_151': '绳索单臂下拉',
    'ex_152': '绳索反向T字拉伸',
    'ex_153': '绳索反向弯举',
    'ex_154': '绳索集中弯举',
    'ex_155': '绳索窄距下压',
    'ex_156': '绳索反向下压',
    'ex_157': '绳索手腕弯举',
    'ex_158': '绳索手腕反向弯举',
    'ex_159': '绳索V字卷腹',
    'ex_160': '绳索悬垂举腿',
    'ex_161': '绳索侧向卷腹',
    'ex_162': '绳索单侧卷腹',
    'ex_163': '绳索反向卷腹',
    'ex_164': '绳索站立旋转',
    'ex_165': '绳索抗旋转',
    'ex_166': '绳索单腿死虫式',
    'ex_167': '绳索单腿后踢',
    'ex_168': '绳索侧向踢腿',
    'ex_169': '绳索髋屈举膝',
    'ex_170': '绳索髋桥',
    'ex_171': '绳索侧卧腿抬',
    'ex_172': '绳索后踢腿',
    'ex_173': '绳索侧向跨步',
    'ex_174': '绳索单腿硬拉',
    'ex_175': '绳索农夫行走',
    'ex_176': '绳索抗阻力行走',
    'ex_177': '绳索多平面拉伸',
    'ex_178': '绳索平衡训练',
    'ex_179': '绳索敏捷梯配合',
    'ex_180': '绳索爆发力训练',
  };


 }