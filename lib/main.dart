import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_package_installer/android_package_installer.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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
  String versionUrl = 'https://nextcloud.eternal-legend.com.br/index.php/s/version/download/version.txt';
  String? downloadPath;
  String currentVersion = 'v0.1';
  String? serverVersion;

  ValueNotifier<double> downloadProgress = ValueNotifier(0.0);
  ValueNotifier<double> downloadedMBs = ValueNotifier(0.0);
  ValueNotifier<double> totalMBs = ValueNotifier(0.0);

  CancelToken cancelToken = CancelToken();
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Solicita permissões de armazenamento e instalação de pacotes
    final storageStatus = await Permission.manageExternalStorage.request();
    final installStatus = await Permission.requestInstallPackages.request();

    if (storageStatus.isGranted && installStatus.isGranted) {
      print('Permissões concedidas.');
      _initializeDownloadPath();
    } else {
      print('Permissões negadas.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissões negadas.')),
      );
    }
  }

  Future<void> _initializeDownloadPath() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      setState(() {
        downloadPath = '${directory.path}/game.apk';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível acessar o diretório de armazenamento.')),
      );
    }
  }

  Future<void> _checkForUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String localVersion = prefs.getString('local_version') ?? currentVersion;

    try {
      final response = await dio.get(versionUrl);
      serverVersion = response.data.trim();

      if (serverVersion != null) {
        if (_compareVersions(localVersion, serverVersion!) < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nova versão disponível! Baixando...')),
          );
          await downloadAndInstall();
          prefs.setString('local_version', serverVersion!);
        } else if (_compareVersions(localVersion, serverVersion!) == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Aplicativo já está atualizado.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('A versão do servidor está desatualizada.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar a versão no servidor.')),
      );
    }
  }

  int _compareVersions(String localVersion, String serverVersion) {
    List<String> localParts = localVersion.replaceAll('v', '').split('.');
    List<String> serverParts = serverVersion.replaceAll('v', '').split('.');

    for (int i = 0; i < localParts.length; i++) {
      int localPart = int.parse(localParts[i]);
      int serverPart = int.parse(serverParts[i]);

      if (localPart < serverPart) {
        print('Versão local é mais antiga.');
        return -1;
      }
      if (localPart > serverPart) {
        print('Versão local é mais recente.');
        return 1;
      }
    }
    print('Versões são iguais.');
    return 0;
  }

  Future<void> downloadAndInstall() async {
    print('Iniciando download e instalação...');
    if (downloadPath != null) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Baixando Atualização'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: downloadProgress,
                    builder: (context, progress, child) {
                      return LinearProgressIndicator(value: progress);
                    },
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder<double>(
                    valueListenable: downloadedMBs,
                    builder: (context, downloaded, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: totalMBs,
                        builder: (context, total, child) {
                          return Text('${downloaded.toStringAsFixed(2)} MB de ${total.toStringAsFixed(2)} MB baixados');
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: downloadProgress,
                    builder: (context, progress, child) {
                      return Text('${(progress * 100).toStringAsFixed(0)}% concluído');
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    print('Download cancelado pelo usuário.');
                    cancelToken.cancel('Download cancelado pelo usuário.');
                    Navigator.of(context).pop();
                    setState(() {
                      isDownloading = false;
                    });
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );
          },
        );

        isDownloading = true;
        await dio.download(
          gameUrl,
          downloadPath!,
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              double progress = received / total;
              double mbDownloaded = received / (1024 * 1024);
              double mbTotal = total / (1024 * 1024);

              downloadProgress.value = progress;
              downloadedMBs.value = mbDownloaded;
              totalMBs.value = mbTotal;

              print('Download: ${downloadedMBs.value.toStringAsFixed(2)} MB de ${totalMBs.value.toStringAsFixed(2)} MB');
            }
          }).then((_) {
            print('Download concluído.');
            Navigator.of(context).pop();
          }).catchError((e) {
            print('Falha ao baixar o jogo: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Falha ao baixar o jogo.')),
            );
          });

        final result = await AndroidPackageInstaller.installApk(apkFilePath: downloadPath!);

        if (result != null) {
          print('Instalação iniciada: ${PackageInstallerStatus.byCode(result).name}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Instalação iniciada: ${PackageInstallerStatus.byCode(result).name}')),
          );
        } else {
          print('Falha ao iniciar a instalação.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao iniciar a instalação.')),
          );
        }
      } catch (e) {
        print('Falha ao baixar o jogo: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao baixar o jogo.')),
        );
      }
    } else {
      print('Caminho de download não definido.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Caminho de download não definido.')),
      );
    }
  }

  @override
  void dispose() {
    print('Destruindo o estado (_LauncherHomeState)...');
    downloadProgress.dispose();
    downloadedMBs.dispose();
    totalMBs.dispose();
    cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Construindo a interface (_LauncherHomeState)...');
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Launcher'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: downloadPath == null || isDownloading ? null : _checkForUpdate,
          child: Text('Verificar Atualizações'),
        ),
      ),
    );
  }
}
