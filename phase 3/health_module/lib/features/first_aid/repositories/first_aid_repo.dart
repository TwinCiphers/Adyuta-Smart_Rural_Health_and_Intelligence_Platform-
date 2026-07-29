import 'package:health_module/core/db/database_helper.dart';
import '../models/emergency_scenario.dart';
import '../models/first_aid_step.dart';

class FirstAidRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<EmergencyScenario>> getEmergencyTopics() async {
    final db = await _dbHelper.getDatabase('firstaid.db');
    final List<Map<String, dynamic>> maps = await db.query('emergency_topics');
    
    List<EmergencyScenario> scenarios = [];
    
    for (var map in maps) {
      int id = map['id'];
      
      List<String> dangerSigns = [];
      try {
        final dangerMaps = await db.query('danger_signs', where: 'topic_id = ?', whereArgs: [id]);
        dangerSigns = dangerMaps.map((m) => m['sign_text'] as String).toList();
      } catch (_) {}
      
      List<Map<String, String>> avoidActions = [];
      try {
        final avoidMaps = await db.query('avoid_actions', where: 'topic_id = ?', whereArgs: [id]);
        avoidActions = avoidMaps.map((m) => {
          'action': m['action_text'] as String,
          'reason': m['reason_text'] as String,
        }).toList();
      } catch (_) {}
      
      List<Map<String, String>> referralRules = [];
      try {
        final refMaps = await db.query('referral_rules', where: 'topic_id = ?', whereArgs: [id]);
        referralRules = refMaps.map((m) => {
          'rule': m['rule_text'] as String,
          'level': m['referral_level'] as String,
        }).toList();
      } catch (_) {}
      
      scenarios.add(EmergencyScenario.fromMap(
        map, 
        dangerSigns: dangerSigns, 
        avoidActions: avoidActions, 
        referralRules: referralRules,
      ));
    }
    
    return scenarios;
  }
  
  Future<List<FirstAidStep>> getStepsForTopic(int topicId) async {
    final db = await _dbHelper.getDatabase('firstaid.db');
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_steps',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'step_no ASC',
    );
    return List.generate(maps.length, (i) {
      return FirstAidStep.fromMap(maps[i]);
    });
  }
}
