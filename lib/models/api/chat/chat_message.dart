enum ChatRole { ai, user }

class ChatMessage {
  final String? text;
  final String? imagePath;
  ChatRole? chatRole;

  ChatMessage({this.chatRole, this.text, this.imagePath});
}
