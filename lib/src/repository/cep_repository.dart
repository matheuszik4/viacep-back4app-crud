
import 'package:viacep/src/model/cep_model.dart';
import 'package:viacep/src/services/back4app.dart';

class CepRepository {

  final back4app = Back4App();

  CepRepository();

  Future<List<CepModel>> index() async {
    var result = await back4app.dio.get('/CEP');
    return CepModel.fromJsonCollection(result.data);
  }

  Future<void> create(CepModel cepModel) async {
    try {
      await back4app.dio.post("/CEP", data: cepModel.toJsonEndpoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(String objectId) async {
    try {
      await back4app.dio.delete("/CEP/$objectId");
    } catch (e) {
      throw e;
    }
  }

  Future<CepModel> show(String cepShow) async {
    List<CepModel> allCeps = await index();
    return allCeps.firstWhere((cep) => cep.cep == cepShow);
  }

  Future<bool> cepAlreadyRegistred(String cepShow) async {
    List<CepModel> allCeps = await index();
    return allCeps.where((cep) => cep.cep == cepShow).isNotEmpty;
  }

}