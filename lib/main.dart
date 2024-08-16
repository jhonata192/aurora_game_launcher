import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_package_installer/android_package_installer.dart';
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
  String? downloadPath;

  @override
  void initState() {
    super.initState();
    _initializeDownloadPath();
  }

  Future<void> _initializeDownloadPath() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      setState(() {
        downloadPath = '${directory.path}/game.apk';
      });
    } else {
      // Trate o caso em que o diretório não pode ser obtido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível acessar o diretório de armazenamento.')),
      );
    }
  }

  Future<void> downloadAndInstall() async {
    if (await Permission.storage.request().isGranted &&
        await Permission.requestInstallPackages.request().isGranted) {
      if (downloadPath != null) {
        try {
          // Baixa o arquivo APK
          await dio.download(gameUrl, downloadPath!, onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          });

          // Após o download, abre o instalador do APK
          final result = await AndroidPackageInstaller.installApk(apkFilePath: downloadPath!);

          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Instalação do jogo iniciada: ${PackageInstallerStatus.byCode(result).name}')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Falha ao iniciar a instalação.')),
            );
          }
        } catch (e) {
          print('Erro ao baixar o jogo: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao baixar o jogo.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Caminho de download não definido.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de armazenamento ou instalação de pacotes negada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Launcher')),
      body: Center(
        child: ElevatedButton(
          onPressed: downloadPath == null ? null : downloadAndInstall,
          child: Text('Baixar e Instalar Jogo'),
        ),
      ),
    );
  }
}
