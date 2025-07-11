class ApiConfig {
  // Base URL API (Ganti dengan URL backend-mu)
  static const String baseUrl = 'https://6b36e71c2e32.ngrok-free.app/api';

  // 🔐 AUTH (Login & Register)
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';

  // 📰 ARTICLES
  static String get articles => '$baseUrl/articles';
  static String articleById(int id) => '$baseUrl/articles/$id';

  // 📊 INTENSITAS
  static String get intensitas => '$baseUrl/intensitas';
  static String intensitasById(int id) => '$baseUrl/intensitas/$id';

  // 💧 DRINK SCHEDULES
  static String get drinkSchedules => '$baseUrl/drink-schedules';
  static String drinkScheduleById(int id) => '$baseUrl/drink-schedules/$id';
}
