import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_busca_cep/widgets/my_text.dart';
import 'package:http/http.dart' as http;
import '../../colors/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController controllerCep = TextEditingController();
  //permite que o valor seja null
  String? estado = '';
  String? cidade = '';
  String? rua = '';

  //focusNode para o campo de texto
  FocusNode cepFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //adiciona um listener para quando o campo de texto receber foco
    //um listener é usado para monitorar mudanças de estado
    cepFocusNode.addListener(() {});
  }

  @override
  void dispose() {
    //dispose do FocusNode quando não for mais necessário
    cepFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false; //variavel loading

  Future<void> searchCep(String cep) async {
    setState(() {
      isLoading = true; //inicializar o loading como verdadeiro
    });

    String url = 'https://viacep.com.br/ws/$cep/json/';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    setState(() {
      estado = json['uf'];
      cidade = json['localidade'];
      rua = json['logradouro'];
      isLoading =
          false; //depois que retornar o que foi pedido, o loading encerra
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); //remove o foco do campo de texto ao tocar em qualquer lugar da tela
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor,
                AppColors.secondaryColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: SizedBox(
                              width: 330,
                              height: 140,
                              child: Image.asset('assets/images/placa.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 82, right: 82),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controllerCep,
                            focusNode: cepFocusNode,
                            onTap: () {
                              //limpa os resultados da busca anterior ao receber foco
                              setState(() {
                                estado = null;
                                cidade = null;
                                rua = null;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'DIGITE SEU CEP',
                              labelStyle: TextStyle(fontSize: 22.0),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 22.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                            style: const TextStyle(fontSize: 22.0),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                //verifica se o CEP tem exatamente 8 números
                                if (controllerCep.text.length == 8 &&
                                    int.tryParse(controllerCep.text) != null) {
                                  searchCep(controllerCep.text);
                                } else {
                                  //mostra um snackbar informando ao usuário sobre o formato incorreto do CEP
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Digite um CEP válido com 8 dígitos.'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 6, //sombra no botão
                                shadowColor: Colors.black,
                                backgroundColor: Colors.grey.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'PESQUISAR',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.search,
                                      color: AppColors.primaryColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 75, right: 75, top: 20),
                          child: estado != null &&
                                  cidade != null &&
                                  rua != null //!= diferente, && e, || ou
                              ? isLoading == true //== igual
                                  ? const CircularProgressIndicator() //? condicional ternaria se
                                  : MyText(
                                      text:
                                          '$rua, $cidade, $estado.') //: condicional ternaria senao
                              : MyText(
                                  text:
                                      'CEP inexistente, digite novamente um CEP válido.',
                                  fontSize: 20,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: SizedBox(
                  width: 280,
                  height: 180,
                  child: Image.asset('assets/images/mapa.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
