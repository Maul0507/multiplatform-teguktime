// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teguk_time/main.dart'; // Ganti sesuai dengan nama proyekmu

void main() {
  testWidgets('Menampilkan pesan minum air', (WidgetTester tester) async {
    // Bangun widget aplikasi
    await tester.pumpWidget(WaterReminderApp());

    // Periksa apakah teks 'Waktunya minum air!' muncul
    expect(find.text('Waktunya minum air!'), findsOneWidget);

    // Periksa apakah jumlah air saat ini (misal 900/1200ml) muncul
    expect(find.text('900/1200 ml'), findsOneWidget);
  });
}
