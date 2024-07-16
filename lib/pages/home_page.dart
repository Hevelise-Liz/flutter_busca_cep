import 'package:flutter/material.dart';
import 'package:flutter_busca_cep/controllers/cep_controller.dart';

import 'package:flutter_busca_cep/models/cep_model.dart';
import 'package:flutter_busca_cep/widgets/my_text.dart';

import '../colors/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  // Controlador de texto para o campo de entrada do CEP
  TextEditingController controllerCep = TextEditingController();

  // FocusNode para controlar o foco do campo de entrada
  FocusNode cepFocusNode = FocusNode();

  // Modelo para armazenar os dados do CEP
  var cep = CepModel();

  // Controlador para buscar o CEP
  final controller = CepController();

  // Flag para controlar a exibição da mensagem inicial
  bool initialMessage = true;

  @override
  void initState() {
    super.initState();

    // Listener para detectar quando o campo de entrada ganha foco
    cepFocusNode.addListener(() {
      if (cepFocusNode.hasFocus) {
        setState(() {
          initialMessage =
              true; // Mostra a mensagem inicial quando o campo de entrada estiver em foco
          cep = CepModel(); // Limpa os dados da busca anterior
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose do FocusNode para liberar recursos
    cepFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Remove o foco do campo de entrada ao tocar em qualquer lugar da tela
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
                              child: Image.asset(
                                  'assets/images/placa.png'), // Imagem de cabeçalho
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 82, right: 82),
                          child: TextFormField(
                            keyboardType: TextInputType
                                .number, // Tipo de teclado numérico
                            controller:
                                controllerCep, // Controlador do campo de entrada
                            focusNode:
                                cepFocusNode, // FocusNode do campo de entrada
                            onTap: () {
                              setState(() {
                                controllerCep
                                    .clear(); // Limpa o texto do campo de entrada
                                controller.isError =
                                    false; // Reseta o estado de erro no controlador
                                initialMessage =
                                    true; // Mostra a mensagem inicial
                                cep =
                                    CepModel(); // Limpa os dados da busca anterior
                                FocusScope.of(context)
                                    .requestFocus(cepFocusNode); // Foca no campo de entrada para mostrar o teclado
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
                              onPressed: () async {
                                FocusScope.of(context)
                                    .unfocus(); // Remove o foco do campo de entrada para ocultar o teclado
                                if (controllerCep.text.length == 8 &&
                                    int.tryParse(controllerCep.text) != null) {
                                  try {
                                    cep = await controller
                                        .searchCep(controllerCep.text);
                                    setState(() {
                                      initialMessage =
                                          false; // Oculta a mensagem inicial após a pesquisa
                                    });
                                  } catch (e) {
                                    // O erro será tratado no controller
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: MyText(
                                          text:
                                              'Digite um CEP válido com 8 dígitos.',
                                          fontSize: 13),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 6,
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
                              left: 44, right: 44, top: 20),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              if (controller.isLoading) {
                                return const CircularProgressIndicator(); // Mostra o indicador de carregamento se estiver carregando
                              }

                              if (controller.isError) {
                                return const MyText(
                                  text:
                                      'CEP inexistente, digite um CEP válido.', // Mostra a mensagem de erro se houver um erro
                                  fontSize: 20,
                                );
                              }

                              if (initialMessage) {
                                return const MyText(
                                  text: '', // Mostra a mensagem inicial
                                  fontSize: 20,
                                );
                              }

                              return MyText(
                                text:
                                    '${cep.cep}, ${cep.estado}, ${cep.cidade}, ${cep.bairro}, ${cep.rua}.', // Mostra os dados do CEP pesquisado
                              );
                            },
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
                  child:
                      Image.asset('assets/images/mapa.gif'), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
