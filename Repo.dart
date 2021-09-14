import 'package:rajasthanstudio/Bloc/Event.dart';
import 'Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepositoryImpl{
  Future<List<Photos>> getPhotos(int length) async {
    http.Response response;
    final queryParameters = {
      'page': "1",
      'per_page': length.toString(),
    };
      response = await http.get(
          Uri.http("api.pexels.com", "/v1/curated", queryParameters),
          headers: {"Authorization" : "563492ad6f917000010000010b33724961504c619f895e220a45858f"}
      );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Photos> photos =  PhotosModelClass.fromJson(data).photos;
      return photos;
    } else {
      throw Exception();
    }
  }
}