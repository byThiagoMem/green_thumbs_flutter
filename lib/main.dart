import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_notifications_tutorial/home_page.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      //Canal da configuração por clique
      NotificationChannel(
        //Chave para identificar o canal
        channelKey: 'basic_channel',
        //Nome que vai aparecer nas configurações de notificação do dispositivo
        channelName: 'Basic Notifications',
        //Cor do ícone de notificação do Android
        defaultColor: Colors.teal,
        //Definimos a importancia da notificação para que ela seja exibida na tela
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      //Canal da configuração agendada
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notification',
        defaultColor: Colors.teal,
        //Essa opção torna a notificação indispensável, obrigando o usuário a realizar uma ação
        locked: true,
        importance: NotificationImportance.High,
        //Definindo um som personalizado
        soundSource: 'resource://raw/res_custom_notification',
      )
    ],
  );
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.tealAccent,
      ),
      title: 'Green Thumbs',
      home: HomePage(),
    );
  }
}
