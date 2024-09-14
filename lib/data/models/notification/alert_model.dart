import '../../../utils/helper/sectionabale.dart';

class AlertModel with Sectionabale<String> {
  String? id;
  String? referenceGuid;
  String? referenceId;
  String? guid;
  String? title;
  String? body;
  String? referenceSoftwareGuid;
  String? alertDate;
  String? date;
  String? senderTitle;

  AlertModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'] ?? '',
        referenceGuid = json['ReferenceGuid'] ?? '',
        referenceId = json['ReferenceId'] ?? '',
        guid = json['Guid'],
        title = json['Title'] ?? '',
        body = json['Body'] ?? '',
        referenceSoftwareGuid = json['ReferenceSoftwareGuid'] ?? '',
        alertDate = json['AlertDate'] ?? '',
        date = json['BoDatedy'] ?? '',
        senderTitle = json['SenderTitle'] ?? '';

  @override
  String getHeader() {
    return 'date!.substring(0, 10)';
  }
}
