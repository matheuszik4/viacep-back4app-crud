
import 'package:flutter/material.dart';
import 'package:viacep/src/model/cep_model.dart';
import 'package:viacep/src/repository/cep_repository.dart';
import 'package:viacep/src/services/back4app.dart';
import 'package:viacep/src/services/viacep_service.dart';

class ListCepsView extends StatefulWidget {
  const ListCepsView({super.key, required this.title});

  final String title;

  @override
  State<ListCepsView> createState() => _ListCepsViewState();
}

class _ListCepsViewState extends State<ListCepsView> {

  final _cepController = TextEditingController();
  List<CepModel> cepModel = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final cepRepository = CepRepository();
    this.cepModel = await cepRepository.index();
    setState(() {});
  }

  deleteCep(String objectId) async {
    final cepRepository = CepRepository();
    await cepRepository.delete(objectId);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: cepModel.length, 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cepModel[index].cep), 
            subtitle: Text('${cepModel[index].logradouro} - ${cepModel[index].localidade}/${cepModel[index].uf}'),
            leading: const Icon(Icons.gps_fixed), 
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteCep(cepModel[index].objectId);
                },
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            _cepController.text = '';

            return AlertDialog(
              title: const Text('Consultar CEP'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _cepController,
                      decoration: const InputDecoration(
                        labelText: 'CEP',
                        hintText: 'Digite o cep',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget> [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    String cep = _cepController.text;

                    if (cep.isEmpty) {
                      return;
                    }

                    final viaCepService = ViaCepService();
                    final cepRepository = CepRepository();

                    final endereco = await viaCepService.show(cep);

                    print('endereco');
                    print(endereco);
                    
                    if (endereco != null) {
                      if (await cepRepository.cepAlreadyRegistred(endereco.cep)) {
                        Navigator.of(context).pop();
                      } else {
                        cepRepository.create(
                          CepModel(
                            cep: endereco.cep, 
                            logradouro: endereco.logradouro, 
                            complemento: endereco.complemento, 
                            bairro: endereco.bairro, 
                            localidade: endereco.localidade, 
                            uf: endereco.uf
                            )
                        );
                      }
                    } else {
                      print('CEP não encontrado');
                      Navigator.of(context).pop();
                      return;
                    }

                    print('Adicionando CEP....');
                    Navigator.of(context).pop();
                    this.getData();
                  },
                  child: const Text('Consultar CEP'),
                ),
              ]
            );
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ), 
    );
  }
}
