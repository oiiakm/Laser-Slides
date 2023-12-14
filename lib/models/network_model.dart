
class NetworkModel {
  late int id;
  late String outgoingIpAddress;
  late int outgoingPort;
  late String startPath;
  late String incomingIpAddress;
  late int incomingPort;
  late int listenForIncomingMessages;

  NetworkModel({
    required this.id,
    required this.outgoingIpAddress,
    required this.outgoingPort,
    required this.startPath,
    required this.incomingIpAddress,
    required this.incomingPort,
    required this.listenForIncomingMessages,
  });

  factory NetworkModel.fromMap(Map<String, dynamic> map) {
    return NetworkModel(
      id: map['id'],
      outgoingIpAddress: map['outgoingIpAddress'],
      outgoingPort: map['outgoingPort'],
      startPath: map['startPath'],
      incomingIpAddress: map['incomingIpAddress'],
      incomingPort: map['incomingPort'],
      listenForIncomingMessages: map['listenForIncomingMessages'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'outgoingIpAddress': outgoingIpAddress,
      'outgoingPort': outgoingPort,
      'startPath': startPath,
      'incomingIpAddress': incomingIpAddress,
      'incomingPort': incomingPort,
      'listenForIncomingMessages': listenForIncomingMessages,
    };
  }
}
