import 'package:flutter/material.dart';

void main() {
  runApp(const UltraFitApp());
}

class UserProfile {
  String id;
  String name;
  String avatar;
  int waterLogged;
  int waterGoal;
  int steps;
  int caloriesConsumed;
  int calorieTarget;
  String activeGoal;
  List<Map<String, String>> chatHistory;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatar,
    this.waterLogged = 0,
    this.waterGoal = 3000,
    this.steps = 0,
    this.caloriesConsumed = 0,
    this.calorieTarget = 2400,
    this.activeGoal = "General Fitness",
    List<Map<String, String>>? chatHistory,
  }) : chatHistory = chatHistory ?? [
    {"sender": "bot", "text": "Hello! I am your AI fitness assistant. How can I adjust your metrics today?"}
  ];
}

class UltraFitApp extends StatelessWidget {
  const UltraFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UltraFit AI Multi-User',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        useMaterial3: true,
      ),
      home: const MultiUserDashboard(),
    );
  }
}

class MultiUserDashboard extends StatefulWidget {
  const MultiUserDashboard({super.key});

  @override
  State<MultiUserDashboard> createState() => _MultiUserDashboardState();
}

class _MultiUserDashboardState extends State<MultiUserDashboard> {
  final List<UserProfile> _users = [
    UserProfile(
      id: "u1",
      name: "Rohan",
      avatar: "👨‍💻",
      waterLogged: 1500,
      waterGoal: 3200,
      steps: 7200,
      caloriesConsumed: 1450,
      calorieTarget: 2500,
      activeGoal: "Calisthenics & Strength",
    ),
    UserProfile(
      id: "u2",
      name: "Family Member",
      avatar: "🏃",
      waterLogged: 1000,
      waterGoal: 2500,
      steps: 4500,
      caloriesConsumed: 1100,
      calorieTarget: 2000,
      activeGoal: "Endurance & Cardio",
    ),
  ];

  late String _activeUserId;
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _newUserNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeUserId = _users.first.id;
  }

  UserProfile get currentUser =>
      _users.firstWhere((u) => u.id == _activeUserId, orElse: () => _users.first);

  void _addNewUser(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      final newUser = UserProfile(
        id: "u_\${DateTime.now().millisecondsSinceEpoch}",
        name: name.trim(),
        avatar: "👤",
      );
      _users.add(newUser);
      _activeUserId = newUser.id;
    });
    _newUserNameController.clear();
    Navigator.of(context).pop();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New User Profile"),
        content: TextField(
          controller: _newUserNameController,
          decoration: const InputDecoration(
            labelText: "User Name",
            hintText: "Enter profile name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => _addNewUser(_newUserNameController.text),
            child: const Text("Create Profile"),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    final text = _chatController.text.trim();
    final user = currentUser;

    setState(() {
      user.chatHistory.add({"sender": "user", "text": text});
      _chatController.clear();
    });

    // Simulated Gemini Vision & Function Calling engine execution
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        final lower = text.toLowerCase();
        if (lower.contains("water") || lower.contains("glass") || lower.contains("drank")) {
          user.waterLogged += 350;
          user.chatHistory.add({
            "sender": "bot",
            "text": "Scanned container: Detected ~350ml water glass. Updated \${user.name}'s hydration log and synced with Health Connect!"
          });
        } else if (lower.contains("food") || lower.contains("plate") || lower.contains("scan") || lower.contains("calorie")) {
          user.caloriesConsumed += 650;
          user.chatHistory.add({
            "sender": "bot",
            "text": "Gemini Vision Plate Analysis: Identified Indian Thali (~650 kcal, 28g Protein). Updated \${user.name}'s daily intake!"
          });
        } else if (lower.contains("goal") || lower.contains("target")) {
          user.activeGoal = "HIIT & Core Conditioning";
          user.chatHistory.add({
            "sender": "bot",
            "text": "Updated active fitness profile goal to 'HIIT & Core Conditioning'!"
          });
        } else {
          user.chatHistory.add({
            "sender": "bot",
            "text": "Synced metrics across Galaxy Watch Ultra & Google Fit for \${user.name}."
          });
        }
      });
    });
  }

  void _simulateCameraScan(String scanType) {
    final user = currentUser;
    setState(() {
      if (scanType == "food") {
        user.caloriesConsumed += 520;
        user.chatHistory.add({
          "sender": "bot",
          "text": "[Camera Scanner]: Scanned meal -> Estimated 520 kcal (High Protein). Added to \${user.name}'s log!"
        });
      } else {
        user.waterLogged += 500;
        user.chatHistory.add({
          "sender": "bot",
          "text": "[Camera Scanner]: Container volume detected -> 500ml water bottle. Synced with Health Connect!"
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UltraFit AI Multi-User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: "Add User",
            onPressed: _showAddUserDialog,
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: "Sync Watch & Health Connect",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Synced \${user.name}\'s data with Galaxy Watch Ultra & Google Fit')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Switcher Bar
            const Text("Active Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final u = _users[index];
                  final isSelected = u.id == _activeUserId;
                  return GestureDetector(
                    onTap: () => setState(() => _activeUserId = u.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected ? Border.all(color: Colors.cyanAccent, width: 2) : null,
                      ),
                      child: Row(
                        children: [
                          Text(u.avatar, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Health Connect & Galaxy Watch Metrics Card
            Card(
              color: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Watch & Fit Sync (\${user.name})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                        const Icon(Icons.watch, color: Colors.cyanAccent),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricTile("Steps", "\${user.steps}", Icons.directions_walk, Colors.cyan),
                        _buildMetricTile("Hydration", "\${user.waterLogged}/\${user.waterGoal}ml", Icons.local_drinking, Colors.blue),
                        _buildMetricTile("Calories", "\${user.caloriesConsumed}/\${user.calorieTarget}", Icons.local_fire_department, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI Camera Vision Trigger Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade800, padding: const EdgeInsets.all(14)),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text("Scan Food Plate", style: TextStyle(color: Colors.white)),
                    onPressed: () => _simulateCameraScan("food"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade800, padding: const EdgeInsets.all(14)),
                    icon: const Icon(Icons.local_see, color: Colors.white),
                    label: const Text("Scan Water Glass", style: TextStyle(color: Colors.white)),
                    onPressed: () => _simulateCameraScan("water"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // AI Chatbot State Alteration Panel
            Text("AI Assistant & System Tool Executor (\${user.name})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: user.chatHistory.length,
                itemBuilder: (context, index) {
                  final msg = user.chatHistory[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.deepPurple.shade700 : Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(msg['text']!, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'e.g. "I drank 300ml" or "Change goal for \${user.name}"',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.cyanAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
