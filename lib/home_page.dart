import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_notifications_tutorial/notifications.dart';
import 'package:flutter_awesome_notifications_tutorial/plant_stats_page.dart';
import 'package:flutter_awesome_notifications_tutorial/utilities.dart';
import 'package:flutter_awesome_notifications_tutorial/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //Verifica se o app tem permissão para enviar notificações, ele retorna um bool
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      // Se o resultado for false, não temos permissão, então exibir dialog
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Permitir notificações'),
                  content: Text(
                      'Nosso aplicativo gostaria de enviar notificações para você'),
                  actions: [
                    //Negar permissão
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Não permitir',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 18))),
                    //Encaminhar o usuário para as permissões
                    TextButton(
                        onPressed: () => AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((_) => Navigator.pop(context)),
                        child: Text('Permitir',
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )))
                  ]);
            });
      }
    });
    //Criando uma Stream para ouvir quando uma notificação é criada e tomar alguma decisão
    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notificação criada em ${notification.channelKey}'),
      ));
    });

    //Criando uma Stream para ouvir o fluxo de ação das notificações
    AwesomeNotifications().actionStream.listen((notification) {
      //Verificamos o canal da notificação e se a plataforma é o IOS para fazer o decremento do número de notificações no ícone
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        //Aqui ocorre o dispose da notificação, então com o get() obtemos o número atual de notificações
        AwesomeNotifications().getGlobalBadgeCounter().then(
            //e decrementamos ela em 1
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PlantStatsPage()),
        (route) => route.isFirst,
      );
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantStatsPage(),
                ),
              );
            },
            icon: Icon(
              Icons.insert_chart_outlined_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlantImage(),
            SizedBox(
              height: 25,
            ),
            HomePageButtons(
              onPressedOne: createPlantFoodNotification,
              onPressedTwo: () async {
                //Primeiro selecionamos o dia e hora chamando a função 'pickSchedule' da classe utilities
                NotificationWeekAndTime? pickedSchedule =
                    await pickSchedule(context);
                if (pickedSchedule != null) {
                  createWaterReminderNotification(pickedSchedule);
                }
              },
              onPressedThree: cancelScheduleNotification,
            ),
          ],
        ),
      ),
    );
  }
}
