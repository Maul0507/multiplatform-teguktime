import 'dart:async';
import 'package:flutter/material.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => BottomNavController(),
      },
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
        onReturnToHome: () async {
          setState(() => _selectedIndex = 0);
          final intensitasProvider = Provider.of<IntensitasProvider>(
            _homeKey.currentContext!,
            listen: false,
          );
          final target = intensitasProvider.targetAir;
          print("ini target $target");

          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('dailyTarget', target!.toDouble());
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
          BottomNavigationBarItem(icon: Icon(Icons.opacity), label: 'Intensitas'),
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
  List<Map<String, dynamic>> _logs = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late Timer _sliderTimer;
  late Timer _cleanupTimer;

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
  _cleanupTimer = Timer.periodic(
    Duration(minutes: 1),
    (_) => _removeExpiredLogs(),
  );
  _loadSavedTarget(); // Pindah ke sini
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedTarget();
  }

  void _startSlider() {
    _sliderTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _currentPage = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _removeExpiredLogs() {
    final now = DateTime.now();
    setState(() {
      _logs.removeWhere((log) {
        final logTime = log['time'] as DateTime;
        final isToday = logTime.day == now.day &&
            logTime.month == now.month &&
            logTime.year == now.year;
        final isPast = logTime.isBefore(now);
        return isToday && isPast;
      });
      _progress = _logs.fold(0.0, (sum, log) => sum + log['amount']);
    });
  }

  void _loadSavedTarget() async {
  final provider = Provider.of<IntensitasProvider>(context, listen: false);
  final prefs = await SharedPreferences.getInstance();
  final savedTarget = prefs.getDouble('dailyTarget');
  print('Loaded target: $savedTarget');
  if (savedTarget != null) {
    provider.setTargetAir(savedTarget.toInt());
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
    _sliderTimer.cancel();
    _cleanupTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                    Consumer<IntensitasProvider>(
                      builder: (context, provider, _) {
                        final goal = provider.targetAir?.toDouble() ?? 0.0;
                        final progress = (_progress / (goal == 0 ? 1 : goal)).clamp(0.0, 1.0);

                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: progress),
                          duration: Duration(milliseconds: 800),
                          builder: (context, value, _) => Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Column(
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
                                    "${goal.toInt()} ml / hari",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: Icon(Icons.local_drink),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddDrinkScreen()),
                        );
                        if (result != null) {
                          _addDrink(result['amount'], result['time']);
                        }
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
            ),
          ),
        ],
      ),
    );
  }
}