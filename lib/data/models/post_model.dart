class PostModel {
  final String title;
  final String body;
  final int id;

  PostModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'],
        id = json['id'];
}
