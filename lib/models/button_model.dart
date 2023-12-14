class ButtonModel {
  late int id;
  late String buttonName;
  late String buttonPressed;

  ButtonModel({
    required this.id,
    required this.buttonName,
    required this.buttonPressed,
  });

  factory ButtonModel.fromMap(Map<String, dynamic> map) {
    return ButtonModel(
      id: map['id'],
      buttonName: map['buttonName'],
      buttonPressed: map['buttonPressed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buttonName': buttonName,
      'buttonPressed': buttonPressed,
    };
  }
}