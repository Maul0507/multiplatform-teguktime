import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'providers/user_provider.dart';
import 'providers/artikel_provider.dart';
import 'providers/intensitas_provider.dart';
import 'providers/schedules_provider.dart';

// Views
import 'views/login_screen.dart';
import 'views/add_drink_screen.dart';
import 'views/register_screen.dart';
import 'views/intensitas_screen.dart';
import 'views/riwayat_screen.dart';
import 'views/profile_screen.dart';
import 'views/wave_clipper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ArtikelProvider()),
        ChangeNotifierProvider(create: (_) => IntensitasProvider()),
        ChangeNotifierProvider(create: (_) => SchedulesProvider()),
      ],
      child: WaterReminderApp(),
    ),
  );
}

class WaterReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {'/': (context) => LoginScreen()},
      initialRoute: '/',
    );
  }
}

class BottomNavController extends StatefulWidget {
  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _selectedIndex = 0;
  final GlobalKey<WaterReminderScreenState> _homeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      WaterReminderScreen(key: _homeKey),
      IntensitasScreen(
        onReturnToHome: () => setState(() => _selectedIndex = 0),
        onTargetCalculated: (ml) async {
          // Ubah target dan simpan
          _homeKey.currentState?.setTarget(ml);
          _homeKey.currentState?.addAutoDrink(ml);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('dailyTarget', ml);
        },
      ),
      RiwayatScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            label: 'Intensitas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({Key? key}) : super(key: key);

  @override
  WaterReminderScreenState createState() => WaterReminderScreenState();
}

class WaterReminderScreenState extends State<WaterReminderScreen> {
  double _progress = 0.0;
  double _goal = 0.0;
  List<Map<String, dynamic>> _logs = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/images/slide1.png',
    'assets/images/slide2.png',
    'assets/images/slide3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startSlider();
    _removeExpiredLogs();
  }

  // ✅ Tambahkan ini agar target diperbarui setiap kali kembali ke layar Home
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedTarget();
  }

  void _startSlider() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _currentPage = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _removeExpiredLogs() {
    Timer.periodic(Duration(minutes: 1), (_) {
      final now = DateTime.now();
      setState(() {
        _logs.removeWhere((log) => log['time'].day != now.day);
        _progress = _logs.fold(0, (sum, log) => sum + log['amount']);
      });
    });
  }

  void _loadSavedTarget() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTarget = prefs.getDouble('dailyTarget');
    if (savedTarget != null) {
      setState(() {
        _goal = savedTarget;
      });
    }
  }

  void _addDrink(double amount, DateTime time) {
    setState(() {
      _logs.add({'amount': amount, 'time': time});
      _progress += amount;
    });
  }

  void addAutoDrink(double amount) {
    final now = DateTime.now();
    _addDrink(amount, now);
  }

  void setTarget(double newTarget) {
    setState(() {
      _goal = newTarget;
    });
  }

  void _editDrink(int index) async {
    final log = _logs[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddDrinkScreen(
          editLog: {'amount': log['amount'], 'time': log['time']},
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _progress -= _logs[index]['amount'];
        _logs[index] = result;
        _progress += result['amount'];
      });
    }
  }

  void _deleteDrink(int index) {
    setState(() {
      _progress -= _logs[index]['amount'];
      _logs.removeAt(index);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(height: 200, color: Colors.lightBlue[100]),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(height: 180, color: Colors.lightBlue[300]),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(height: 160, color: Colors.blue),
                ),
                Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            final user = userProvider.user;
                            return Text(
                              'Hi, ${user?.name ?? "User"}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gimana kabar kamu hari ini?',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, i) => Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(_images[i], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 15.0,
                    percent: (_goal == 0)
                        ? 0
                        : (_progress / _goal).clamp(0.0, 1.0),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_progress.toInt()} ml',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'dari ${_goal.toInt()} ml',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.grey[300]!,
                    progressColor: Colors.blueAccent,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.local_drink),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddDrinkScreen()),
                      );
                      if (result != null)
                        _addDrink(result['amount'], result['time']);
                    },
                    label: Text('Tambah Minum'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _logs.isEmpty
                      ? Center(child: Text('Belum ada catatan minum'))
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _logs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final log = _logs[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text('${log['amount']} ml'),
                                subtitle: Text('${log['time']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _editDrink(index),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteDrink(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
