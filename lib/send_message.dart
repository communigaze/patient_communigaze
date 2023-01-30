import 'chat_message.dart';
import 'glassmorphism_card.dart';
import 'data_service.dart';

class SendMessage {
  SendMessage({required this.content});
  String content;
  DatabaseService _db = DatabaseService();
  void sendTextMessage() {
    ChatMessage _messageToSend = ChatMessage(
      content: content,
      type: MessageType.TEXT,
      senderID: 'QoTpAZd2PkeLmPmXNHLmSyUcSLE2',
      sentTime: DateTime.now(),
    );
    _db.addMessageToChat('jAE1z9zN1aES2rGlQrOL', _messageToSend);
  }
}
