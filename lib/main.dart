import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'check Internet connection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//variabel untuk mengecek apakah terhubung ke internet
late bool isConnected;

// objek untuk memeriksa koneksi internet
final Connectivity _connectivity = Connectivity();

late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    // set nilai awal status koneksi sebagai true(terhubung)
    isConnected = true;

    //memanggil fungsi pengecekan koneksi internet dan mendengarkan perubahan koneksi setelah selesai
    _initConnectionStatus().then((_){
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
        setState(() {
          isConnected = !result.contains(ConnectivityResult.none);
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Batalkan Langganan saat widget dihancurkan untuk menghindari memory leak(kobocoran memori)
    _connectivitySubscription.cancel();
  }

  // Fungsi untuk memeriksa status koneksi internet saat pertama kali aplikasi dijalankan
  Future<void> _initConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      // Perbarui Status Koneksi Berdasarkan hasil pengecekan
      isConnected = !result.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child :AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Image.asset(
            isConnected 
              ? 'assets/connected.png'
              : 'assets/disconnected.png',
            key :ValueKey<bool>(isConnected),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}