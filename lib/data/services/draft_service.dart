import 'dart:convert';

import 'package:http/http.dart' as http;

class LetterService<T> {
  static const fetchLimit = 15;
  final baseUrl =
      'http://rc.didgah.chargoon.net/api/didgah/automation/documentmanager/Version/V20240630/Folder/Draft/GetAll/';

  Future<List<dynamic>> fetchDraft(T page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl?encFolderID=1GXOS4NrT2rJM8I9ntH31A&folderFlag=21&encStaffID=FSVCJcywBKM4TKsL-Qhyzg&pageNo=$page&pageSize=$fetchLimit&encPartitionID=null'),
        headers: {
          'Cookie':
              'ASP.NET_SessionId=fipgec5w1gcstiizb3gqnwbi%248G1WlHnV_1614huBZxLtbdEDzv6tntZK15XG78vIhN0%24; UserDeviceIdentifier=d2f89963-0bc7-4a8e-a6b8-4464493f43c9;',
          'User-Agent': 'Android SDK built for x86_64 Android',
        },
      );
      return jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      throw Exception();
    }
  }
}
