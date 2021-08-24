import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_awesome_notifications_tutorial/utilities.dart';

//Função para criar uma notificação sobre clique
Future<void> createPlantFoodNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      //Importante criar um id único, para que sempre crie uma nova notificação
      id: createUniqueId(),
      //channelKey deve ser a mesma chave do canal que pretendemos exibir a notificação
      channelKey: 'basic_channel',
      title:
          '${Emojis.money_money_bag + Emojis.plant_cactus} Compre alimentos vegetais!!!',
      body: 'A florista em 123 Main St. tem 2 em estoque',
      bigPicture: 'asset://assets/notification_map.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}

//Função para criar uma notificação agendada
Future<void> createWaterReminderNotification(
    NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title:
          '${Emojis.wheater_droplet} Adicione um pouco de água à sua planta!',
      body: 'Regue sua planta regularmente para mantê-la saudável',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        //A key é para que se necessário podermos identificar o botão e quando clicado executar alguma ação
        key: 'MARK_DONE',
        //O label é o título do botão
        label: 'Mark Done',
      ),
    ],
    //Aqui vamos configurar o Agendamento
    schedule: NotificationCalendar(
      //Dia da semana, que estamos passando por parâmetro
      weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}

//Função para cancelar uma notificação agendada
Future<void> cancelScheduleNotification() async {
  await AwesomeNotifications().dismissAllNotifications();
}
