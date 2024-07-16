import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_busca_cep/models/cep_model.dart';
import 'package:http/http.dart' as http;

class CepController extends ChangeNotifier {
  bool isLoading = false;
  bool isError = false;

  Future<CepModel> searchCep(String cep) async {
    isLoading = true;
    isError = false;
    notifyListeners(); //tá escutando pra passar pra home_page

    try {
      String url = 'https://viacep.com.br/ws/$cep/json/';
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);

      if (response.statusCode != 200 || json.containsKey('erro')) {
        throw Exception('CEP inexistente, digite novamente um CEP válido.');
      }

      isLoading = false;
      notifyListeners();
      return CepModel.fromJson(json);
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      return CepModel(); //retorna um modelo vazio em caso de erro
    }
  }
}
