import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

void main() => runApp(GameLauncher());

class GameLauncher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LauncherHome(),
    );
  }
}

class LauncherHome extends StatefulWidget {
  @override
  _LauncherHomeState createState() => _LauncherHomeState();
}

class _LauncherHomeState extends State<LauncherHome> {
  Dio dio = Dio();
  String gameUrl = 'https://masterjf-solucoes.com.br/downloads/android/fernandes-image-describer.apk';
  String downloadPath = '/storage/emulated/0/Download/game.apk';

  Future<void> downloadAndInstall() async {
    try {
      // Baixa o arquivo APK
      await dio.download(gameUrl, downloadPath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });

      // Após o download, abre o instalador do APK
      OpenFile.open(downloadPath);
    } catch (e) {
      print('Erro ao baixar o jogo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao baixar o jogo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Launcher')),
      body: Center(
        child: ElevatedButton(
          onPressed: downloadAndInstall,
          child: Text('Baixar e Instalar Jogo'),
        ),
      ),
    );
  }
}
