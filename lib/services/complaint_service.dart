import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pengaduan_masyarakat/models/complaint_model.dart';
import '../common/constant.dart';
import 'package:path/path.dart' as path;

class ComplaintService {
  AndroidOptions _getAndroidOptions() {
    return const AndroidOptions(
      encryptedSharedPreferences: true,
    );
  }

  Future<ComplaintModel> create(
    String userId,
    String aduan,
    FilePickerResult? bukti,
  ) async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String apiURL = "${baseAPIURL()}/create-pengaduan";
    String? token = await storage.read(
      key: "token",
      aOptions: _getAndroidOptions(),
    );

    try {
      var request = MultipartRequest(
        'POST',
        Uri.parse(apiURL),
      );
      request.headers.addAll(
        header(
          true,
          token: token,
        ),
      );

      request.fields.addAll(
        {
          'user_id': userId,
          'aduan': aduan,
        },
      );

      if (bukti != null) {
        File file = File(bukti.files.single.path!);
        var stream = ByteStream(file.openRead());
        stream.cast();
        var length = await file.length();

        request.files.add(
          MultipartFile(
            "bukti",
            stream,
            length,
            filename: path.basename(file.path),
          ),
        );
      }

      Response response = await Response.fromStream(
        await request.send(),
      );

      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
        // print(jsonObject);

        return ComplaintModel.fromJson(jsonObject);
      } else {
        var jsonObject = jsonDecode(response.body);
        // print(jsonObject);

        return ComplaintModel.fromJson(jsonObject);
      }
    } catch (e) {
      // print(e);
      throw Exception("Pengaduan Gagal. Error: $e");
    }
  }
}
