import 'package:flutter/material.dart';

void main() {
  runApp(const NexusFieldApp());
}

class NexusFieldApp extends StatelessWidget {
  const NexusFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexusField',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FieldDashboardScreen(),
    );
  }
}

class FieldDashboardScreen extends StatefulWidget {
  const FieldDashboardScreen({super.key});

  @override
  State<FieldDashboardScreen> createState() => _FieldDashboardScreenState();
}

class _FieldDashboardScreenState extends State<FieldDashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _fieldTasks = [
    {'title': 'Sensor Node Check - Sector A', 'status': 'Completed', 'priority': 'High', 'time': '09:30 AM'},
    {'title': 'Firmware Update ESP32-CAM', 'status': 'In Progress', 'priority': 'Critical', 'time': '11:15 AM'},
    {'title': 'Battery Replacement (Node 4)', 'status': 'Pending', 'priority': 'Medium', 'time': '02:00 PM'},
    {'title': 'Inventory Audit - Warehouse B', 'status': 'Pending', 'priority': 'Low', 'time': '04:30 PM'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NexusField Operations', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All field systems nominal. No active alerts.')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Statistics Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('Active Nodes', '18/20', Icons.lan, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Pending Tasks', '3', Icons.task_alt, Colors.orange)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Field Tasks & Telemetry Queue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Task List View
            Expanded(
              child: ListView.builder(
                itemCount: _fieldTasks.length,
                itemBuilder: (context, index) {
                  final task = _fieldTasks[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getPriorityColor(task['priority']),
                        child: const Icon(Icons.assignment, color: Colors.white),
                      ),
                      title: Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Status: ${task['status']}  •  Scheduled: ${task['time']}'),
                      trailing: Chip(
                        label: Text(task['priority'], style: const TextStyle(fontSize: 12, color: Colors.white)),
                        backgroundColor: _getPriorityColor(task['priority']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Syncing offline cache with central server...')),
          );
        },
        label: const Text('Sync Data'),
        icon: const Icon(Icons.sync),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.deepOrange;
      case 'Medium': return Colors.amber.shade800;
      default: return Colors.green;
    }
  }
}