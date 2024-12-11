import 'package:dio/dio.dart';
import 'package:viacep/src/model/cep_model.dart';

class ViaCepService {
  final Dio dio = Dio();

  String baseUrl = 'https://viacep.com.br/ws';

  String baseFormat = 'json';

  Future<CepModel?> show(String cep) async {
    try {
      final response = await dio.get('${baseUrl}/$cep/${baseFormat}/');
      print(response.data);
      print(response.statusCode);
      print(CepModel.fromJson(response.data));
      if (response.statusCode == 200) {
        return CepModel.fromJson(response.data);
      } else {
        print('Erro: Não foi possível encontrar o endereço.');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
      return null;
    }
  }
}
