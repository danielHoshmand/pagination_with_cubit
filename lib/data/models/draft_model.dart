class DraftModel {
  final String draftInstanceId;
  final String draftId;
  final String sender;
  final String date;
  final String subject;
  final String receivers;

  DraftModel({
    required this.draftInstanceId,
    required this.draftId,
    required this.sender,
    required this.date,
    required this.subject,
    required this.receivers,
  });

  DraftModel.fromJson(Map<String, dynamic> json)
      : draftInstanceId = json['DraftInstanceId'] ?? '',
        draftId = json['DraftId'] ?? '',
        sender = json['Sender'] ?? '',
        date = json['Date'],
        subject = json['Subject'] ?? '',
        receivers = json['Receivers'] ?? '';
}
